#!/usr/bin/env python3

from pathlib import Path
import pexpect.fdpexpect
import re
import serial
import sys

from .ftdi import Ftdi
from .uboot import X4xxUboot
from .crosec import X4xxChromiumEC
from .linux import Linux
from .jtag import XilinxJtag


class BufferWrapper:
    def __init__(self, towrap, encoding):
        self.towrap = towrap
        self.encoding = encoding

    def write(self, bs):
        try:
            s = bs.decode(self.encoding)
            self.towrap.write(s)
        except UnicodeDecodeError:
            self.towrap.write("!!! decode failed !!!")

    def flush(self):
        self.towrap.flush()


class Titanium:
    def __init__(self, ftdi_serial):
        self.ftdi = Ftdi(ftdi_serial)
        self.scu_file = self.ftdi.get_uart(2)
        self.ps_file = self.ftdi.get_uart(3)
        self.xjtag = XilinxJtag("Digilent", "JTAG-ONB6", ftdi_serial)

    def __enter__(self):
        self.scu_fd = serial.Serial(self.scu_file, 115200, timeout=0)
        self.scu = pexpect.fdpexpect.fdspawn(self.scu_fd.fileno())
        self.scu.logfile = BufferWrapper(sys.stderr, 'ascii')

        self.ps_fd = serial.Serial(self.ps_file, 115200, timeout=0)
        self.ps = pexpect.fdpexpect.fdspawn(self.ps_fd.fileno())
        self.ps.logfile = BufferWrapper(sys.stderr, 'ascii')

        return self

    def __exit__(self, type, value, traceback):
        try:
            self.scu.close()
        except:
            print("SCU close failed")
        try:
            self.ps.close()
        except:
            print("PS close failed")

    @property
    def uboot(self):
        return X4xxUboot(self.ps)

    @property
    def linux(self):
        return Linux(self.ps)

    @property
    def crosec(self):
        return X4xxChromiumEC(self.scu, self.ftdi.serial)

    def jtag_download_to_ram(self, filename, address):
        assert Path(filename).exists()

        if type(address) is int:
            addr_hex = hex(address)
        else:
            addr_hex = address

        script = f'''
        targets -set -filter {{name =~ "Cortex-A53 #0"}}
        dow -data "{filename}" {addr_hex}
        '''

        with self.xjtag.xsdb() as xsdb:
            xsdb.run_script(script, cwd=Path(filename).parent)

    def boot_uboot(self, tcl_script):
        assert Path(tcl_script).exists()

        # read provided tcl script
        script = ""
        with open(tcl_script, "r") as f:
            script = f.read()

        # remove the "connect" command
        script = re.sub(r"^connect.*$", "", script, flags=re.MULTILINE)

        # run the tctl script
        with self.xjtag.xsdb() as xsdb:
            xsdb.run_script(script, cwd=Path(tcl_script).parent)

    def get_product_and_rev(self):
        self.ps.sendline("eeprom-id mb")
        self.ps.expect("eeprom-id mb\r\n")
        line = self.ps.readline().decode()
        match = re.match(r"product=ni-([^-]+)-rev([0-9]+)", line)
        self.ps.expect("#")
        if match is None:
            raise RuntimeError(f"Could not parse product and revision from '{line}'")
        return match.group(1), match.group(2)
