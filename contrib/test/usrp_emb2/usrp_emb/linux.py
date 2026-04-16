from labgrid.target import Target
from labgrid.driver import ShellDriver
from labgrid.driver import SerialDriver
from pexpect import EOF

class Linux():


    def __init__(self, target: Target):
        self.target : Target = target
        self.shell : ShellDriver = self.target.get_driver("ShellDriver", activate=False)
        self.serial : SerialDriver = self.target.get_driver("SerialDriver", activate=False, name="ps_console")


    def activate_shell(self):
        self.target.activate(self.shell)


    def deactivate_shell(self):
        self.target.deactivate(self.shell)


    def activate_serial(self):
        self.target.activate(self.serial)


    def login(self):
        self.activate_shell()


    def get_hostname(self):
        self.activate_shell()
        stdout, stderr, returncode = self.shell.run("hostname")
        return stdout[0]


    def get_root_dev(self):
        self.activate_shell()
        stdout, stderr, returncode = self.shell.run("mount | grep 'on / ' | cut -d' ' -f 1")
        if returncode != 0:
            raise RuntimeError(f"get_root_dev failed, stdout: {stdout}, stderr: {stderr}, returncode: {returncode}")
        return stdout[0]


    def get_eth0_addr(self):
        self.activate_shell()
        addresses = self.shell.get_ip_addresses("eth0")
        return addresses[0].ip


    def wait_for_power_down(self):
        self.activate_serial()
        timeout = 300
        self.serial.expect(['reboot: Power down', EOF], timeout)


    def wait_for_panic(self):
        self.activate_serial()
        self.serial.expect('Kernel panic')


    def poweroff(self):
        self.activate_shell()
        self.target.get_strategy().transition("poweroff")


    def run(self, cmd, timeout=30.0):
        self.activate_shell()
        return self.shell.run(cmd, timeout=timeout)


    def sync(self):
        self.activate_shell()
        self.activate_serial()
        self.serial.sendline("sync")
        self.serial.expect("#")


    def mount(self, dev, mountpoint):
        self.activate_shell()
        stdout, stderr, returncode = self.shell.run(f"mkdir -p {mountpoint}")
        assert returncode == 0
        stdout, stderr, returncode = self.shell.run(f"mount {dev} {mountpoint}")
        assert returncode == 0


    def rm(self, path):
        self.activate_shell()
        stdout, stderr, returncode = self.shell.run(f"rm -f {path}")
        assert returncode == 0
