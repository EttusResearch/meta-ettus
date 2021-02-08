#!/usr/bin/env python3

from pathlib import Path
import pexpect.fdpexpect
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
            xsdb.run_script(script)

    def boot_uboot(self, pmu_elf, spl_bin, uboot_elf, atf_elf):
        assert Path(pmu_elf).exists()
        assert Path(spl_bin).exists()
        assert Path(uboot_elf).exists()
        assert Path(atf_elf).exists()

        script = f'''
            targets -set -nocase -filter {{name =~ "PSU"}}

            mwr 0xFFCA0038 0x1FF
            after 500

            targets -set -filter {{name =~ "MicroBlaze PMU"}}

            # download PMU firmware
            dow "{pmu_elf}"
            con
            after 500

            targets -set -nocase -filter {{name =~ "PSU"}}

            mwr 0xffff0000 0x14000000

            # bring APU 0 out of reset
            # https://www.xilinx.com/html_docs/registers/ug1087/crf_apb___rst_fpd_apu.html
            mwr 0xfd1a0104 0x380e

            targets -set -filter {{name =~ "Cortex-A53 #0"}}

            # download u-boot SPL
            dow -data "{spl_bin}" 0xfffc0000
            rwr pc 0xfffc0000
            after 5000
            stop

            # download u-boot and ARM trusted firmware
            dow "{uboot_elf}"
            dow "{atf_elf}"
            con
        '''

        with self.xjtag.xsdb() as xsdb:
            xsdb.run_script(script)
