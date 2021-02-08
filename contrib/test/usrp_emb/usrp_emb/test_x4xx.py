#!/usr/bin/env python3

from .titanium import Titanium
from .tftp import TFTPServer
from .httpd import HTTPServer
import inspect
import json
import os
import time
import unittest
import xmlrunner
from pathlib import Path

FTDI_SERIAL = os.environ['USRP_EMB_FTDI_SERIAL']
BRINGUP_PATH = Path(os.environ['USRP_EMB_IMAGE_PATH'])

POSSIBLE_ROOTDEVS = {'/dev/mmcblk0p2', '/dev/mmcblk0p3'}

def flash_scu():
    with Titanium(FTDI_SERIAL) as ti:
        ti.crosec.flash_scu(BRINGUP_PATH / 'ec.bin')
        time.sleep(5)
        print("Version after flashing")
        print(ti.crosec.version())


def flash_emmc():
    with Titanium(FTDI_SERIAL) as ti:
        ti.crosec.reboot()
        ti.crosec.set_bootmode('jtag')
        ti.crosec.powerbtn()

        ti.boot_uboot(
            pmu_elf=BRINGUP_PATH / "pmu-firmware.elf",
            spl_bin=BRINGUP_PATH / "u-boot-spl.bin",
            uboot_elf=BRINGUP_PATH / "u-boot.elf",
            atf_elf=BRINGUP_PATH / "bl31.elf")

        ti.uboot.wait_for_uboot()
        ti.uboot.stop_autoboot()

        ip = ti.uboot.run_dhcp()
        addr = 0x40000000

        with TFTPServer(BRINGUP_PATH / "fitImage-manufacturing", ip) as server:
            ti.uboot.tftp(server.ip, server.port, server.filename, addr)

        ti.uboot.bootm(addr, '#conf@ni_${variant}.dtb')
        ti.linux.login()

        with HTTPServer(BRINGUP_PATH, ip) as server:
            image_name = list(BRINGUP_PATH.glob("*.sdimg.bz2"))[0].name
            ti.linux.bmap_copy(server.get_url(image_name), "/dev/mmcblk0")

        ti.linux.poweroff()

        ti.crosec.reboot()
        ti.crosec.set_bootmode('emmc')
        ti.crosec.powerbtn()

        ti.uboot.wait_for_uboot()
        ti.linux.login()
        ti.linux.poweroff()


def boot_and_login(ti):
    """ Helper to boot normally and get the target IP """
    ti.crosec.reboot()
    ti.crosec.powerbtn()
    ti.uboot.wait_for_uboot()
    ti.linux.login()


def check_mender_config_sanity(ti):
    var_conf = ti.linux.read_text('/var/lib/mender/mender.conf')
    etc_conf = ti.linux.read_text('/etc/mender/mender.conf')

    # Two cases:
    #  - fresh install, no mender updates: etc_conf contains the partition
    #    info, var_conf is empty
    #  - after an update: var_conf contains the partition info
    #
    if var_conf == '':
        conf = etc_conf
    else:
        conf = var_conf

    conf = json.loads(conf)
    assert conf['RootfsPartA'] == '/dev/mmcblk0p2'
    assert conf['RootfsPartB'] == '/dev/mmcblk0p3'


def mender_update():
    with Titanium(FTDI_SERIAL) as ti:
        mender_file = list(BRINGUP_PATH.glob("*.mender"))[0].name

        boot_and_login(ti)

        ip = ti.linux.get_eth0_addr()
        print(ip)

        check_mender_config_sanity(ti)

        orig_rootdev = ti.linux.get_root_dev()
        print("orig rootdev: ", orig_rootdev)
        assert orig_rootdev in POSSIBLE_ROOTDEVS

        with HTTPServer(BRINGUP_PATH, ip) as server:
            url = server.get_url(mender_file)
            dest_rootdev = ti.linux.mender_install(url)

        assert dest_rootdev in POSSIBLE_ROOTDEVS
        ti.linux.reboot()
        ti.uboot.wait_for_uboot()
        ti.linux.login()

        new_rootdev = ti.linux.get_root_dev()
        print("new rootdev: ", new_rootdev)
        assert new_rootdev in POSSIBLE_ROOTDEVS
        assert new_rootdev == dest_rootdev
        assert orig_rootdev != new_rootdev

        ti.linux.mender_commit()

        ti.linux.reboot()
        ti.uboot.wait_for_uboot()
        ti.linux.login()

        rootdev = ti.linux.get_root_dev()
        print("rootdev: ", rootdev)
        assert rootdev in POSSIBLE_ROOTDEVS

        assert new_rootdev == rootdev

        check_mender_config_sanity(ti)


def boot_linux():
    with Titanium(FTDI_SERIAL) as ti:
        boot_and_login(ti)
        ip = ti.linux.get_eth0_addr()
        print(ip)


class EmbeddedTests(unittest.TestCase):
    def test_boot_auto_linux(self):
        """
        Test to ensure the board automatically boots into Linux successfully
        """
        with Titanium(FTDI_SERIAL) as ti:
            boot_and_login(ti)
            ti.linux.sync()
            ti.crosec.reboot()

    def test_linux_shutdown(self):
        with Titanium(FTDI_SERIAL) as ti:
            boot_and_login(ti)
            assert ti.crosec.powerinfo() == 'S0'
            ti.crosec.powerbtn()
            ti.linux.wait_for_power_down()
            ti.crosec.flush()
            for i in range(30):
                time.sleep(1)
                if ti.crosec.powerinfo() == 'G3':
                    break
            assert ti.crosec.powerinfo() == 'G3'

    def test_scu_read_version(self):
        with Titanium(FTDI_SERIAL) as ti:
            print(ti.crosec.version())

    def test_scu_power_leds(self):
        BUTTON_LED_GREEN_L = 'PWRDB_PWRLEDA_L'
        BUTTON_LED_RED_L = 'PWRDB_PWRLEDB_L'
        BACK_LED_GREEN_L = 'PWRDB_LED3G_L'
        BACK_LED_RED_L = 'PWRDB_LED3R_L'

        with Titanium(FTDI_SERIAL) as ti:
            ti.crosec.reboot()

            # After a reboot: power button LEDs off, back LED amber
            assert ti.crosec.ioexget(BUTTON_LED_GREEN_L) == True
            assert ti.crosec.ioexget(BUTTON_LED_RED_L) == True

            assert ti.crosec.ioexget(BACK_LED_GREEN_L) == False
            assert ti.crosec.ioexget(BACK_LED_RED_L) == False

            ti.crosec.powerbtn()
            time.sleep(1)
            assert ti.crosec.powerinfo() == 'S0'

            # in S0: power button green, back LED green
            assert ti.crosec.ioexget(BUTTON_LED_GREEN_L) == False
            assert ti.crosec.ioexget(BUTTON_LED_RED_L) == True

            assert ti.crosec.ioexget(BACK_LED_GREEN_L) == False
            assert ti.crosec.ioexget(BACK_LED_RED_L) == True

            ti.uboot.wait_for_uboot()
            ti.linux.login()

            # still in S0: power button green, back LED green
            assert ti.crosec.ioexget(BUTTON_LED_GREEN_L) == False
            assert ti.crosec.ioexget(BUTTON_LED_RED_L) == True

            assert ti.crosec.ioexget(BACK_LED_GREEN_L) == False
            assert ti.crosec.ioexget(BACK_LED_RED_L) == True

            ti.linux.poweroff()

            ti.crosec.flush()
            for i in range(30):
                time.sleep(1)
                if ti.crosec.powerinfo() == 'G3':
                    break
            assert ti.crosec.powerinfo() == 'G3'

            # After shutdown: power button LED off, back LED amber
            assert ti.crosec.ioexget(BUTTON_LED_GREEN_L) == True
            assert ti.crosec.ioexget(BUTTON_LED_RED_L) == True

            assert ti.crosec.ioexget(BACK_LED_GREEN_L) == False
            assert ti.crosec.ioexget(BACK_LED_RED_L) == False


    def test_scu_reboot(self):
        with Titanium(FTDI_SERIAL) as ti:
            ti.crosec.reboot()

    def test_scu_powerinfo_after_reboot(self):
        with Titanium(FTDI_SERIAL) as ti:
            ti.crosec.reboot()
            assert ti.crosec.powerinfo() == 'G3'

    def test_scu_powerinfo_after_powerbtn(self):
        with Titanium(FTDI_SERIAL) as ti:
            ti.crosec.reboot()
            ti.crosec.powerbtn()
            time.sleep(1)
            assert ti.crosec.powerinfo() == 'S0'

    def test_scu_apreset(self):
        with Titanium(FTDI_SERIAL) as ti:
            ti.crosec.reboot()
            ti.crosec.powerbtn()
            ti.uboot.wait_for_uboot()
            ti.uboot.stop_autoboot()
            ti.crosec.apreset()
            ti.uboot.wait_for_uboot()
            ti.crosec.reboot()

    def test_uboot_prompt(self):
        with Titanium(FTDI_SERIAL) as ti:
            ti.crosec.reboot()
            ti.crosec.powerbtn()
            ti.uboot.wait_for_uboot()
            ti.uboot.stop_autoboot()

    def test_uboot_reset(self):
        with Titanium(FTDI_SERIAL) as ti:
            ti.crosec.reboot()
            ti.crosec.powerbtn()
            ti.uboot.wait_for_uboot()
            ti.uboot.stop_autoboot()

            ti.uboot.reset()
            ti.uboot.wait_for_uboot()
            assert ti.crosec.powerinfo() == 'S0'

    def test_uboot_poweroff(self):
        with Titanium(FTDI_SERIAL) as ti:
            ti.crosec.reboot()
            ti.crosec.powerbtn()
            ti.uboot.wait_for_uboot()
            ti.uboot.stop_autoboot()

            assert ti.crosec.powerinfo() == 'S0'
            ti.uboot.poweroff()
            time.sleep(5)
            assert ti.crosec.powerinfo() == 'G3'

    def test_powerbtn_force(self):
        with Titanium(FTDI_SERIAL) as ti:
            ti.crosec.reboot()
            assert ti.crosec.powerinfo() == 'G3'
            ti.crosec.powerbtn()
            ti.uboot.wait_for_uboot()
            ti.uboot.stop_autoboot()
            assert ti.crosec.powerinfo() == 'S0'
            ti.crosec.powerbtn()
            assert ti.crosec.powerinfo() == 'S0'
            ti.crosec.powerbtn(8500)
            time.sleep(5)
            assert ti.crosec.powerinfo() == 'G3'
            ti.crosec.reboot()

    def test_wdt_timeout(self):
        with Titanium(FTDI_SERIAL) as ti:
            ti.crosec.reboot()
            ti.crosec.powerbtn()
            ti.uboot.wait_for_uboot()
            ti.uboot.stop_autoboot()

            # change init to /bin/false, which will cause a panic
            ti.uboot.env_set("bootargs", "${bootargs} init=/bin/false")
            ti.uboot.boot()

            ti.linux.wait_for_panic()
            # Watchdog timer should reset after one minute
            time.sleep(60)

            # validate that we successfully boot into Linux
            ti.uboot.wait_for_uboot()
            ti.linux.login()
            ti.linux.poweroff()

    def test_linux_reboot(self):
        with Titanium(FTDI_SERIAL) as ti:
            boot_and_login(ti)
            ti.linux.reboot()
            ti.uboot.wait_for_uboot()
            ti.linux.login()

    def test_mender_sanity(self):
        with Titanium(FTDI_SERIAL) as ti:
            boot_and_login(ti)
            check_mender_config_sanity(ti)


class MenderTests(unittest.TestCase):
    def test_mender_update(self):
        mender_update()
        mender_update()

    def test_mender_sanity(self):
        with Titanium(FTDI_SERIAL) as ti:
            boot_and_login(ti)
            check_mender_config_sanity(ti)

    def test_mender_update_partial(self):
        with Titanium(FTDI_SERIAL) as ti:
            mender_file = list(BRINGUP_PATH.glob("*.mender"))[0].name

            boot_and_login(ti)

            ip = ti.linux.get_eth0_addr()
            print(ip)

            orig_rootdev = ti.linux.get_root_dev()
            print("orig rootdev: ", orig_rootdev)
            assert orig_rootdev in POSSIBLE_ROOTDEVS

            with HTTPServer(BRINGUP_PATH, ip) as server:
                url = server.get_url(mender_file)
                dest_rootdev = ti.linux.mender_install(url)

            assert dest_rootdev in POSSIBLE_ROOTDEVS
            ti.linux.reboot()
            ti.uboot.wait_for_uboot()
            ti.linux.login()

            new_rootdev = ti.linux.get_root_dev()
            print("new rootdev: ", new_rootdev)
            assert new_rootdev in POSSIBLE_ROOTDEVS
            assert new_rootdev == dest_rootdev
            assert orig_rootdev != new_rootdev

            # Reboot without committing, should be back in the original partition

            ti.linux.reboot()
            ti.uboot.wait_for_uboot()
            ti.linux.login()

            rootdev = ti.linux.get_root_dev()
            print("rootdev: ", rootdev)
            assert rootdev in POSSIBLE_ROOTDEVS

            assert orig_rootdev == rootdev


    def test_mender_update_fail(self):
        with Titanium(FTDI_SERIAL) as ti:
            mender_file = list(BRINGUP_PATH.glob("*.mender"))[0].name

            boot_and_login(ti)

            ip = ti.linux.get_eth0_addr()
            print(ip)

            orig_rootdev = ti.linux.get_root_dev()
            print("orig rootdev: ", orig_rootdev)

            with HTTPServer(BRINGUP_PATH, ip) as server:
                url = server.get_url(mender_file)
                dest_rootdev = ti.linux.mender_install(url)

            # Okay, we've written the image. Now, we're going to break it.
            mtpt = "/mnt/altroot"
            ti.linux.mount(dest_rootdev, mtpt)

            # I dunno, these seem like they might be important?
            ti.linux.rm(mtpt + "/sbin/init")
            ti.linux.rm(mtpt + "/bin/sh")

            ti.linux.reboot()
            ti.uboot.wait_for_uboot()

            # Okay, u-boot should have loaded. Now we'll expect to panic.
            ti.linux.wait_for_panic()
            # wait for watchdog to trigger a reset
            time.sleep(60)

            # Now, we should be booted back into the original image
            ti.uboot.wait_for_uboot()
            ti.linux.login()
            new_rootdev = ti.linux.get_root_dev()
            print("new rootdev: ", new_rootdev)
            assert orig_rootdev == new_rootdev


def suite(test_class):
    def is_test(x):
        return inspect.isfunction(x) and x.__name__.startswith('test_')

    tests = []
    all_tests = inspect.getmembers(test_class, predicate=is_test)
    for test, _ in all_tests:
        tests.append(test)

    suite = unittest.TestSuite()
    for test in tests:
        suite.addTest(test_class(test))
    return suite


def embedded_tests():
    runner = xmlrunner.XMLTestRunner()
    runner.run(suite(EmbeddedTests))


def mender_tests():
    runner = xmlrunner.XMLTestRunner()
    runner.run(suite(MenderTests))


if __name__ == '__main__':
    main()
