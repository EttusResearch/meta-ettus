from labgrid.target import Target
from labgrid.driver import SerialDriver

import time

class SCU:
    

    def __init__(self, target: Target):
        self.target : Target = target
        self.scu : SerialDriver = self.target.get_driver("SerialDriver", name="scu_console", activate=False)


    def activate_scu(self):
        self.target.activate(self.scu)


    def wait_for_powerstate(self, desired_state, timeout=None):
        self.activate_scu()
        start_time = time.time()
        while True:
            self.scu.sendline("powerinfo")
            _, _, match, _ = self.scu.expect("power state (.*),", timeout=1)
            power_state = match.group(1).decode("utf-8")
            if power_state == desired_state:
                return time.time() - start_time
            if (not timeout is None) and (time.time() - start_time > timeout):
                raise TimeoutError(f"Timout of {timeout:.01f} s when transitioning to power state {desired_state}, last state was {power_state}")
            time.sleep(0.1)
