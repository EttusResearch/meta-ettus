#!/usr/bin/env python3

from pathlib import Path
from utils import dt_compatible
import random
import unittest

def find_eeprom(name):
    dt_base = Path("/sys/firmware/devicetree/base")

    with open(dt_base / "__symbols__" / name) as f:
        dt_path = dt_base / f.read()[1:-1]

    for dev in Path("/sys/bus/nvmem/devices").glob("*"):
        of_node_path = dev / "of_node"
        if of_node_path.exists() and dt_path.samefile(of_node_path):
            return dev / "nvmem"

def eeprom_present(name):
    return find_eeprom(name) is not None

@unittest.skipUnless(dt_compatible('x410'), 'not an x410')
class TestX4xxEeprom(unittest.TestCase):
    def test_motherboard_eeprom_present(self):
        self.assertTrue(eeprom_present("mb_eeprom"))

    def test_pwraux_eeprom_present(self):
        self.assertTrue(eeprom_present("pwraux_eeprom"))

    def test_read_motherboard_eeprom(self):
        self._test_read("mb_eeprom")

    def test_read_pwraux_eeprom(self):
        self._test_read("pwraux_eeprom")

    def test_read_db0_eeprom(self):
        self._test_read("db0_eeprom")

    def test_read_db1_eeprom(self):
        self._test_read("db1_eeprom")

    def test_read_dioaux_eeprom(self):
        self._test_read("dioaux_eeprom")

    def test_read_clkaux_eeprom(self):
        self._test_read("clkaux_eeprom")

    def _test_read(self, name):
        eeprom = find_eeprom(name)
        if eeprom is None:
            raise unittest.SkipTest(f'{name} is absent')
        contents = eeprom.read_bytes()
        self.assertEqual(len(contents), 256)

    def test_write_motherboard_eeprom(self):
        self._test_write('mb_eeprom')

    def test_write_pwraux_eeprom(self):
        self._test_write('pwraux_eeprom')

    def test_write_db0_eeprom(self):
        self._test_write('db0_eeprom')

    def test_write_db1_eeprom(self):
        self._test_write('db1_eeprom')

    def test_write_dioaux_eeprom(self):
        self._test_write('dioaux_eeprom')

    def test_write_clkaux_eeprom(self):
        self._test_write('clkaux_eeprom')

    def _test_write(self, name):
        eeprom = find_eeprom(name)
        if eeprom is None:
            raise unittest.SkipTest(f'{name} is absent')
        orig = eeprom.read_bytes()
        with open(f'test_eeproms-{name}.backup', 'wb') as f:
            f.write(orig)
        random_data = bytearray(random.getrandbits(8) for _ in range(len(orig)))
        eeprom.write_bytes(random_data)
        read_back_random = eeprom.read_bytes()
        eeprom.write_bytes(orig)
        self.assertEqual(random_data, read_back_random)
