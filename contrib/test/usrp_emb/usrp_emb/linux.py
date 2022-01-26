#!/usr/bin/env python3

import time
from paramiko.client import MissingHostKeyPolicy
from paramiko.client import SSHClient


class Linux:
    def __init__(self, uart):
        self.uart = uart

    def login(self, username='root', password=None):
        assert password is None
        old_timeout = self.uart.timeout
        self.uart.timeout = 100
        self.uart.expect("login: ")
        self.uart.timeout = old_timeout
        self.uart.sendline(username)
        time.sleep(10)
        self.uart.expect("#")
        self.uart.sendline("dmesg --console-off")
        self.uart.expect("#")
        self.uart.sendline("true")
        self.uart.expect("#")

    def get_eth0_addr(self):
        self.uart.sendline("ip -o -f inet addr")
        self.uart.expect(r"eth0\s+inet\s+([0-9.]+)")
        return self.uart.match.group(1).decode('ascii')

    def get_root_dev(self):
        self.uart.sendline("mount | grep 'on / ' | cut -d' ' -f 1; echo OK")
        self.uart.expect("(/dev/\S+).*OK")
        dev = self.uart.match.group(1).decode('ascii')
        self.uart.expect('#')
        return dev

    def wait_for_power_down(self):
        self.uart.expect('reboot: Power down')

    def wait_for_panic(self):
        self.uart.expect('Kernel panic')

    def poweroff(self):
        self.uart.sendline("poweroff")
        self.wait_for_power_down()

    def reboot(self):
        self.uart.sendline("reboot")
        self.uart.expect("reboot: Restarting system")

    def sync(self):
        self.uart.sendline("sync")
        self.uart.expect("#")

    def bmap_copy(self, url, dest):
        self.uart.sendline("ifconfig -a")
        self.uart.expect("#")
        time.sleep(5)
        self.uart.sendline("ifconfig -a")
        self.uart.expect("#")
        old_timeout = self.uart.timeout
        self.uart.timeout = 900
        self.uart.sendline(f"bmaptool -q copy {url} {dest}; echo bmaptool finished: $?")
        self.uart.expect('bmaptool finished: 0')
        self.uart.timeout = old_timeout

    def mender_install(self, url):
        old_timeout = self.uart.timeout
        self.uart.timeout = 600
        self.uart.sendline(f"mender -install {url}")
        self.uart.expect("Performing remote update from:")
        self.uart.expect("Opening device \"([^\"]+)\" for writing")
        target =  self.uart.match.group(1).decode('ascii')
        self.uart.expect("All bytes were successfully written to the new partition")
        self.uart.expect("At least one payload requested a reboot of the device it updated")
        self.uart.expect("#")
        self.uart.timeout = old_timeout
        return target

    def mender_commit(self):
        self.uart.sendline("mender -commit")
        self.uart.expect("Committing update")

    def mount(self, dev, mountpoint):
        self.uart.sendline(f"mkdir -p {mountpoint} && echo OK")
        self.uart.expect("OK")
        self.uart.expect("#")

        self.uart.sendline(f"mount {dev} {mountpoint} && echo OK")
        self.uart.expect("OK")
        self.uart.expect("#")

    def rm(self, path):
        self.uart.sendline(f"rm -f {path} && echo OK")
        self.uart.expect("OK")
        self.uart.expect("#")

    def run_command(self, command):
        class AcceptHostKeyPolicy(MissingHostKeyPolicy):
            def missing_host_key(self, client, hostname, key):
                return

        ip = self.get_eth0_addr()

        client = SSHClient()
        client.set_missing_host_key_policy(AcceptHostKeyPolicy)

        try:
            client.connect(ip, username='root', password='')
        except:
            print("failed to connect, going to retry in 5 seconds")
            time.sleep(5)
            client.connect(ip, username='root', password='')

        _, stdout, stderr = client.exec_command(command)
        stdout_text = stdout.read().decode('utf-8')
        stderr_text = stderr.read().decode('utf-8')
        exit_code = stdout.channel.recv_exit_status()
        client.close()

        return stdout_text, stderr_text, exit_code

    def run_command_and_print(self, command):
        print("*** running command '{}' ***".format(command))
        stdout_text, stderr_text, code = self.run_command(command)
        print("*** command '{}' returned with exit code {}".format(command, code))
        print("*** stdout begin ***", stdout_text, "*** stdout end ***", sep='\n')
        print("*** stderr begin ***", stderr_text, "*** stderr end ***", sep='\n')
        if code != 0:
            raise RuntimeError("command '{}' failed with exit code {}".format(command, code))

    def read_text(self, path):
        stdout_text, stderr_text, exit_code = self.run_command(f"cat {path}")
        return stdout_text
