#!/usr/bin/env python3

from utils import dt_compatible
import unittest
import subprocess
from pathlib import Path

MMC_BASE = Path("/sys/class/mmc_host/mmc0/mmc0:0001")

class TestEmmc(unittest.TestCase):
    @unittest.skipUnless(dt_compatible('x410'), 'not an x410')
    def test_emmc_pre_eol_info(self):
        info = int((MMC_BASE / 'pre_eol_info').read_text(), 0)
        print("pre_eol_info", info)
        self.assertLess(info, 7)

    @unittest.skipUnless(dt_compatible('x410'), 'not an x410')
    def test_emmc_life_time(self):
        life_times = (MMC_BASE / 'life_time').read_text().split(' ')
        life_times = [int(x, 0) for x in life_times]
        print("life_time", life_times)
        for life in life_times:
            self.assertLess(life, 7)
