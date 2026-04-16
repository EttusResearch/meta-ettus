import json
import logging
import time

from labgrid.target import Target
from labgrid.driver import ShellDriver
from labgrid.driver import SerialDriver
from pexpect import EOF

class Mender():

    POSSIBLE_ROOTDEVS = {'/dev/mmcblk0p2', '/dev/mmcblk0p3'}


    def __init__(self, target: Target):
        self.target : Target = target
        self.shell : ShellDriver = self.target.get_driver("ShellDriver")
        self.serial : SerialDriver = self.target.get_driver("SerialDriver", activate=False, name="ps_console")
        self.log : logging.Logger = logging.getLogger("usrp.mender")


    def activate_shell(self):
        self.target.activate(self.shell)


    def activate_serial(self):
        self.target.activate(self.serial)


    def check_mender_config_sanity(self):
        self.activate_shell()
        stdout, stderr, returncode = self.shell.run('cat /var/lib/mender/mender.conf')
        var_conf = '\n'.join(stdout)
        stdout, stderr, returncode = self.shell.run('cat /etc/mender/mender.conf')
        etc_conf = '\n'.join(stdout)

        # Two cases:
        #  - fresh install, no mender updates: etc_conf contains the partition
        #    info, var_conf is empty
        #  - after an update: var_conf contains the partition info
        #
        try:
            conf = json.loads(var_conf)
        except ValueError:
            # JSON str invalid. var_conf probably empty.
            conf = json.loads(etc_conf)

        assert conf['RootfsPartA'] == '/dev/mmcblk0p2'
        assert conf['RootfsPartB'] == '/dev/mmcblk0p3'


    def mender_install(self, url):
        self.activate_shell()
        self.activate_serial()
        timeout = 10
        write_timeout = 1200
        start_time = time.time()
        self.log.info("starting Mender update")
        self.serial.sendline(f"mender install {url}")
        _, _, match, _ = self.serial.expect(f"Performing remote update from: \[(\S*)\]", timeout)
        assert match.group(1).decode('utf-8') == url
        _, _, match, _ = self.serial.expect("Opening device \"([^\"]+)\" for writing", timeout)
        target = match.group(1).decode('utf-8')
        self.serial.expect("All bytes were successfully written to the new partition", write_timeout)
        elapsed_time = time.time() - start_time
        self.log.info(f"Writing mender image took {elapsed_time:.01f} seconds")
        self.serial.expect("At least one payload requested a reboot of the device it updated", timeout)
        self.serial.expect("#", timeout)
        return target


    def mender_commit(self):
        self.activate_shell()
        stdout, stderr, returncode = self.shell.run("mender commit")
        assert returncode == 0
        assert stdout[0] == "Committing Artifact..."
