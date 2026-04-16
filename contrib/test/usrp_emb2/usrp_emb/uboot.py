#!/usr/bin/env python3

from labgrid.target import Target
from labgrid.driver import SerialDriver, UBootDriver
from pexpect import EOF

class Uboot:


    def __init__(self, target: Target):
        self.target : Target = target
        self.serial : SerialDriver = self.target.get_driver("SerialDriver", activate=False, name="ps_console")
        self.uboot : UBootDriver = self.target.get_driver("UBootDriver", activate=False) 
    

    def reset(self):
        self.target.activate(self.uboot)
        self.uboot.reset()


    def poweroff(self):
        self.target.activate(self.serial)
        self.serial.sendline("poweroff")
        self.serial.expect("poweroff ...")


    def enter_prompt(self):
        self.target.activate(self.uboot)


    def wait_for_uboot(self, timeout=30):
        self.target.activate(self.serial)
        self.serial.expect("U-Boot SPL", timeout=timeout)
        self.serial.expect("U-Boot")


    def wait_for_boot(self, timeout=30):
        self.target.activate(self.serial)
        self.serial.expect(self.uboot.bootstring, timeout=timeout)
