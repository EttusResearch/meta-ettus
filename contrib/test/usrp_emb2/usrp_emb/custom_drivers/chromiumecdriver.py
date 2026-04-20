import attr
import time

from labgrid.factory import target_factory
from labgrid.protocol import ConsoleProtocol
from labgrid.driver.powerdriver import PowerResetMixin, PowerProtocol
from labgrid.driver.common import Driver
from pexpect.exceptions import EOF, TIMEOUT

@target_factory.reg_driver
@attr.s(eq=False)
class ChromiumEcPowerDriver(Driver, PowerResetMixin, PowerProtocol):
    """ChromiumEcDriver - Driver to use power management provided by a
    microcontroller running ChromiumOS Embedded Controller software (Legacy)
    https://chromium.googlesource.com/chromiumos/platform/ec/
    
    ChromiumEcDriver binds on top of a ConsoleProtocol.
    """
    bindings = {"console": {ConsoleProtocol}, }
    delay = attr.ib(default=5, validator=attr.validators.instance_of(int))
    cycle_mode = attr.ib(default="reboot", validator=attr.validators.instance_of(str))
    reboot_autostart = attr.ib(default=False, validator=attr.validators.instance_of(bool))
    watchdog_workaround = attr.ib(default=False, validator=attr.validators.instance_of(bool))
    default_timeout = attr.ib(default=10, validator=attr.validators.instance_of(int))
    on_timeout = attr.ib(default=10, validator=attr.validators.instance_of(int))

    def __attrs_post_init__(self):
        super().__attrs_post_init__()

    def on(self, attempts=3):
        for attempt in range(attempts):
            attempt += 1
            self.console.sendline("powerbtn")
            time.sleep(self.on_timeout)
            self.console.sendline("powerinfo")
            result = self.console.expect(["power state 3 = S0", "AP didn't come up, shutdown"], self.default_timeout)
            if result == 1:
                # failed to transition to power state S0
                if attempt == attempts:
                    raise RuntimeError(f"Error powering on the device in {attempts} attempts")
                continue
            else:
                if attempt > 0:
                    self.logger.warning(f"Needed {attempts} attempts for powering on the device")
                # successfully transitioned to power state S0
                break

    def off(self):
        self.console.sendline("apshutdown")
        time.sleep(2*self.default_timeout)
        self.console.sendline("powerinfo")
        self.console.expect("power state 0 = G3", self.default_timeout)
        time.sleep(2*self.default_timeout)
        self.console.sendline("powerinfo")
        self.console.expect("power state 0 = G3", self.default_timeout)

    def _check_version(self):
        _, _, match, _ = self.console.expect(r"\[Image: (\S+), (\S+) (\S+) (\S+) (\S+)\]", self.default_timeout)
        self.logger.info(f"SCU is running {match.group(0).decode()}")
        ec_version = match.group(2).decode()
        if ec_version in ["sulfur_v1.1.7346-0b98e618a", "sulfur_v1.1.7352-d51614fbc"]:
            self.logger.warning(f"Using watchdog workaround for Image: RO, {ec_version}")
            self.watchdog_workaround = True

    def _cycle_reboot(self):
        self.console.sendline("reboot")
        self.console.expect("UART initialized after reboot", self.default_timeout)
        self.console.expect("Reset cause: reset-pin soft", self.default_timeout)
        self._check_version()
        if self.reboot_autostart:
            # AP is started automatically after reboot
            self.console.expect("power state 4 = G3->S5", self.default_timeout)
            if self.watchdog_workaround:
                # AP is started automatically after reboot but watchdog workaround is needed
                self.console.sendline("apshutdown")
                self.console.expect("power state 0 = G3", self.default_timeout)
                time.sleep(8)
                self.console.sendline("powerbtn")
                index, _, _, _ = self.console.expect(["power state 4 = G3->S5", TIMEOUT], self.default_timeout)
                if index == 1:
                    self.console.sendline("powerbtn")
                    self.console.expect("power state 4 = G3->S5", self.default_timeout)
            self.console.expect("power state 3 = S0", timeout=self.on_timeout)
        else:
            # AP is not started automatically after reboot
            self.console.expect("power state 0 = G3", self.default_timeout)
            self.console.sendline("powerbtn")
            self.console.expect("power state 4 = G3->S5", self.default_timeout)
            self.console.expect("power state 3 = S0", timeout=self.on_timeout)

    def _cycle_apreset(self):
        self.console.sendline("apreset")
        self.console.expect("chipset_reset", timeout=self.on_timeout)
        self.console.expect("power state 3 = S0", timeout=self.on_timeout)

    def cycle(self):
        if self.cycle_mode == "reboot":
            self._cycle_reboot()
        elif self.cycle_mode == "apreset":
            self._cycle_apreset()
        else:
            self.off()
            time.sleep(self.delay)
            self.on()
