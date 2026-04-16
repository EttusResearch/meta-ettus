from labgrid.target import Target
from labgrid.driver import ShellDriver
from labgrid.driver import SerialDriver
from labgrid.exceptions import NoDriverFoundError

from pexpect import EOF

import logging

from .linux import Linux
from .mender import Mender
from .salt_minion import SaltMinion
from .scu import SCU
from .uboot import Uboot

class USRP():


    def __init__(self, target: Target):
        self.target = target
        self.strategy = target.get_strategy()
        self.type = target.env.config.get_target_option(target.name, "type")
        self.product = target.env.config.get_target_option(target.name, "product")
        self.log = logging.getLogger("usrp")
        self.log.info(f"initialized with type={self.type} product={self.product}")


    def enable_autoboot(self, enabled=True):
        if self.type in ['e310_sg1', 'e310_sg3', 'e31x']:
            self.shell = self.target.get_driver("ShellDriver")
            autoboot_file = "/sys/devices/soc0/fpga-full/fpga-full:pmu/autoboot"
            stdout, stderr, returncode = self.shell.run(f"cat {autoboot_file}")
            enabled_str = "enabled" if enabled else "disabled"
            assert returncode == 0
            if stdout == [str(int(enabled))]:
                self.log.info(f"autoboot was already {enabled_str}")
            else:
                stdout, stderr, returncode = self.shell.run(f"echo {int(enabled)} > {autoboot_file}")
                assert returncode == 0
                stdout, stderr, returncode = self.shell.run(f"cat {autoboot_file}")
                assert returncode == 0
                assert stdout == [str(int(enabled))]
                self.log.info(f"{enabled_str} autoboot")


    def boot_and_login(self):
        self.strategy.transition("shell")


    def reboot(self):
        self.strategy.transition("shell")
        self.enable_autoboot()
        self.strategy.transition("reboot")
        self.linux.deactivate_shell()


    def reboot_and_login(self):
        self.reboot()
        self.strategy.transition("shell")


    def reboot_and_stay_in_uboot(self):
        self.reboot()
        self.strategy.transition("uboot")


    def poweroff(self):
        self.strategy.transition("shell")
        self.enable_autoboot()
        self.strategy.transition("poweroff")
        if self.scu:
            transition_time = self.scu.wait_for_powerstate("0 = G3", 30)
            self.log.info(f"transitioning to poweroff state took {transition_time:.01f} seconds")
        self.strategy.transition("off")


    @property
    def uboot(self):
        return Uboot(self.target)


    @property
    def linux(self):
        return Linux(self.target)


    @property
    def mender(self):
        return Mender(self.target)


    @property
    def scu(self):
        try:
            scu = SCU(self.target)
        except NoDriverFoundError:
            scu = None
        return scu


    @property
    def salt_minion(self):
        return SaltMinion(self.target, self.log)
