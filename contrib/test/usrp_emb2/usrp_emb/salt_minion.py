import logging

from labgrid.target import Target
from labgrid.driver import ShellDriver

class SaltMinion():
    def __init__(self, target: Target, log: logging.Logger):
        self.target : Target = target
        self.log : logging.Logger = log
        self.shell : ShellDriver = self.target.get_driver("ShellDriver", activate=False)

 
    def activate_shell(self):
        self.target.activate(self.shell)

 
    def start(self):
        self.activate_shell()
        stdout, stderr, returncode = self.shell.run("systemctl start salt-minion")
        assert returncode == 0, f"Error starting Salt minion: {stderr}"


    def stop(self):
        self.activate_shell()
        stdout, stderr, returncode = self.shell.run("systemctl stop salt-minion")
        assert returncode == 0, f"Error stopping Salt minion: {stderr}"


    def configure(self, key, value):
        stdout, stderr, returncode = self.shell.run(f'sed -i "s|^#*{key}:.*|{key}: {value}|" /etc/salt/minion')
        assert returncode == 0, f"Error setting Salt minion configuration {key}={value}: {stderr}"
