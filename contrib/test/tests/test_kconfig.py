#!/usr/bin/env python3

# Tests to validate kconfig options on the running kernel

import gzip
import unittest

def parse_kconfig():
    kconfig = {}
    with gzip.open('/proc/config.gz', 'r') as f:
        contents = f.read().decode('utf-8')
    lines = contents.split('\n')
    for line in lines:
        if len(line) == 0:
            continue
        if line[0] == '#':
            continue
        k, v = line.split('=')
        kconfig[k] = v
    print("done with kconfig parsing\n")
    return kconfig

KCONFIG = parse_kconfig()

class TestKernelConfig(unittest.TestCase):
    def assertKConfigEnabled(self, option):
        self.assertIn(option, KCONFIG)
        self.assertIn(KCONFIG[option], ['y', 'm'])

    def assertKConfigDisabled(self, option):
        if option in KCONFIG:
            self.assertIn(KCONFIG[option], ['n'])

    def assertKConfigValue(self, option, value):
        self.assertIn(option, KCONFIG)
        if type(value) is str:
            self.assertEqual(KCONFIG[option], '"%s"' % value)
        else:
            self.assertEqual(KCONFIG[option], '%s' % str(value))

    def test_rtc_options(self):
        # set sys time from rtc
        self.assertKConfigEnabled("CONFIG_RTC_HCTOSYS")
        self.assertKConfigValue("CONFIG_RTC_HCTOSYS_DEVICE", "rtc0")

        # ensure kernel syncs time back to rtc
        self.assertKConfigEnabled("CONFIG_RTC_SYSTOHC")
        self.assertKConfigValue("CONFIG_RTC_SYSTOHC_DEVICE", "rtc0")

    def test_led_triggers(self):
        # ensure triggers supported by ledctrl command are present
        triggers = [
            'ACTIVITY',
            'GPIO',
            'HEARTBEAT',
            'NETDEV',
            'PANIC',
        ]

        for trig in triggers:
            self.assertKConfigEnabled('CONFIG_LEDS_TRIGGER_' + trig)

    def test_filesystems(self):
        # ensure common filesystems are supported
        filesystems = [
            'EXT4_FS',
            'FUSE_FS',
            'FAT_FS',
            'MSDOS_FS',
            'VFAT_FS',
            'JFFS2_FS',
            'NFS_FS',
        ]

        for fs in filesystems:
            self.assertKConfigEnabled('CONFIG_' + fs)
