import unittest
from utils import dt_compatible
from pathlib import Path
import mmap
import os
import shutil
import struct
import time

class RemoteProc:
    def __init__(self, idx):
        self.remoteproc = Path('/sys/class/remoteproc/remoteproc%u' % idx) 
        self.firmware = self.remoteproc / 'firmware'
        self.state = self.remoteproc / 'state'

    def load(self, firmware):
        """
        Firmware should be the name of a firmware file in /lib/firmware
        """
        self.firmware.write_text(firmware)

    def start(self):
        if self.get_state != 'running':
            self.state.write_text('start')

            state = self.get_state()
            while state != 'running':
                state = self.get_state()

    def stop(self):
        if self.get_state() == 'running':
            self.state.write_text('stop')

    def get_state(self):
        return self.state.read_text().strip('\n')


class App:
    # From Patrick Sisterhen:
    # > they write 0xBEEFCAFE to the SHARED_DMA_BASE_ADDR+4
    # > they increment a value at SHARED_DMA_BASE_ADDR+8
    # > if you write 0xABCD1234 to SHARED_DMA_BASE_ADDR, it will stop
    # > SHARED_DMA_BASE_ADDR is 0x30100000 or 0x30300000, depending on the core
    def __init__(self, addr):
        self.file = open('/dev/mem', 'r+b')
        self.mm = mmap.mmap(self.file.fileno(), 4096, offset=addr)

    def clear_state(self):
        self.mm[0:4] = struct.pack('<I', 0)
        self.mm[4:8] = struct.pack('<I', 0)
        self.mm[8:12] = struct.pack('<I', 0)

    def stop_incrementing(self):
        self.mm[0:4] = struct.pack('<I', 0xABCD1234)

    def read_signature(self):
        return struct.unpack('<I', self.mm[4:8])[0]

    def check_signature(self):
        return self.read_signature() == 0xBEEFCAFE

    def read_value(self):
        return struct.unpack('<I', self.mm[8:12])[0]


class TestRemoteproc(unittest.TestCase):
    @unittest.skipUnless(dt_compatible('x410'), 'not an x410')
    def test_remoteproc_r5(self):
        PROCS = [('x4xx_rpu_lvfpga_mmap_0.elf', 0x30100000),
                 ('x4xx_rpu_lvfpga_mmap_1.elf', 0x30300000)]

        for (i, (elf, addr)) in enumerate(PROCS):
            shutil.copy(os.path.join(os.path.dirname(os.path.realpath(__file__)), elf),
                        '/lib/firmware')
            rpu = RemoteProc(i)
            app = App(addr)

            rpu.stop()
            rpu.load(elf)
            app.clear_state()

            self.assertFalse(app.check_signature())
            self.assertEqual(app.read_value(), 0)

            rpu.start()

            time.sleep(1)
            self.assertTrue(app.check_signature())
            val0 = app.read_value()
            time.sleep(1)
            val1 = app.read_value()

            self.assertGreater(val1, val0)

            app.stop_incrementing()
            time.sleep(1)

            val0 = app.read_value()
            time.sleep(1)
            val1 = app.read_value()

            self.assertEqual(val0, val1)
            app.clear_state()
