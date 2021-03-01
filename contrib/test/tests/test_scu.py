#!/usr/bin/env python3

import subprocess
import time
import unittest
from utils import package_installed

def run_ectool(*args):
    return subprocess.check_output(['ectool', *args]).decode('utf-8')


class TestScu(unittest.TestCase):
    @unittest.skipUnless(package_installed('chromium-ec-utils'), 'chromium-ec-utils is not installed')
    def test_scu_is_running_rw(self):
        """
        u-boot should always sysjump to the RW section before booting
        """
        output = run_ectool('version')
        self.assertIn('Firmware copy: RW', output)

    @unittest.skipUnless(package_installed('chromium-ec-utils'), 'chromium-ec-utils is not installed')
    def test_stress_scu(self):
        """
        Run stress test on SCU for 5 seconds, validate no failures
        """
        proc = subprocess.Popen(['ectool', 'stress'], stdout=subprocess.PIPE)
        time.sleep(5)
        proc.send_signal(subprocess.signal.SIGINT)
        stdout, _ = proc.communicate()
        self.assertIn(b'Total failures:  0\n', stdout)
