#!/usr/bin/env python3

import subprocess
import tempfile
from pathlib import Path


class ChromiumEC:
    def __init__(self, uart, ftdi_serial=None):
        self.uart = uart
        self.ftdi_serial = ftdi_serial
        self.prompt = '>'

    def _stop_spam(self):
        self.uart.sendline('chan 0')
        self.uart.expect(self.prompt)

    def flush(self):
        self.uart.sendline('help')
        self.uart.expect('HELP LIST')
        self.uart.expect(self.prompt)

    def reboot(self):
        self.uart.sendline('reboot')
        self.uart.expect('--- UART initialized after reboot ---.*')
        self.uart.expect(self.prompt)
        self._stop_spam()

    def apreset(self):
        self.uart.sendline('apreset')
        self.uart.expect('Issuing AP reset...')
        self.uart.expect(self.prompt)

    def powerbtn(self, msec=200):
        self.uart.sendline(f'powerbtn {msec}')
        self.uart.expect(f'Simulating {msec} ms power button press')
        self.uart.expect('Simulating power button release')
        if self.uart.before != '':
            return
            # warnings.warn('errors after powerbtn: ' + str(self.uart.before))
        self.uart.expect(self.prompt)

    def powerinfo(self):
        """ Run powerinfo, return mode """
        self.uart.sendline('powerinfo')
        self.uart.expect(r'\[\d+.\d+ power state \d = \w\w')
        state = self.uart.after[-2:]
        self.uart.expect(self.prompt)
        return state.decode('ascii', 'ignore')

    def version(self):
        self.uart.sendline('version')
        self.uart.expect(self.prompt)
        return self.uart.before.decode('ascii', 'ignore')

    def ro_version(self):
        vers = self.version()
        for line in vers.split('\r\n'):
            if line.startswith('RO'):
                return line.split(':')[1].lstrip()

    def rw_version(self):
        vers = self.version()
        for line in vers.split('\r\n'):
            if line.startswith('RW'):
                return line.split(':')[1].lstrip()

    def sysinfo_copy(self):
        self.uart.sendline('sysinfo')
        self.uart.expect(self.prompt)
        copy = self.uart.before.decode('ascii', 'ignore')
        for line in copy.split('\r\n'):
            if line.startswith('Copy:'):
                return line.split(':')[1].lstrip()

    # regex should have two capture groups:
    # first: [01] for the signal state
    # second: [ *] for the change indicator
    def _ioget(self, cmd, name, regex):
        self.uart.sendline(f'{cmd} {name}')
        self.uart.expect(regex)
        val = self.uart.match.group(1).decode('ascii', 'ignore')
        changed = self.uart.match.group(2).decode('ascii', 'ignore')
        self.uart.expect(self.prompt)
        assert val in ['0', '1']
        assert changed in [' ', '*']
        return val == '1', changed == '*'

    def gpioget(self, name):
        regex = r'\s+([01])([ *])\s*' + name
        return self._ioget('gpioget', name, regex)[0]

    def ioexget(self, name):
        regex = r'\s+([01])([ *])\s*\w\s+\w\s+' + name
        return self._ioget('ioexget', name, regex)[0]


class X4xxChromiumEC(ChromiumEC):
    def __init__(self, uart, ftdi_serial=None):
        super().__init__(uart, ftdi_serial)

    def set_bootmode(self, mode):
        assert mode in ['jtag', 'emmc', 'sd1ls']
        self.uart.sendline(f'zynqmp bootmode {mode}')
        self.uart.expect(f"ZynqMP: Setting 'bootmode' to '{mode}'")
        self.uart.expect(self.prompt)

    def flash_scu(self, filename):
        assert Path(filename).exists()
        serial = self.ftdi_serial

        script = f'''
            interface ftdi
            ftdi_vid_pid 0x0403 0x6011
            ftdi_serial {serial}
            ftdi_channel 1

            ftdi_layout_init 0x0058 0x005b
            ftdi_layout_signal nTRST -data 0x010
            ftdi_layout_signal nSRST -data 0x040 -oe 0x040

            reset_config separate trst_and_srst srst_nogate

            adapter_khz 2000

            transport select jtag

            source [find target/stm32f4x.cfg]

            set WORKAREASIZE 0x40000

            reset_config connect_assert_srst

            gdb_port 3121
            tcl_port 0
            telnet_port 0
            init
            reset init
            flash write_image erase unlock {filename} 0x08000000
            reset halt
            resume
            shutdown
            '''

        with tempfile.NamedTemporaryFile() as f:
            f.write(script.encode('ascii'))
            f.flush()
            subprocess.run(['openocd', '-f', f.name], check=True)
