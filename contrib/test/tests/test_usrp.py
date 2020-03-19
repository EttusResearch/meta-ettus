import unittest
import subprocess
import os
import re
import time
from utils import package_installed

class TestCommon(unittest.TestCase):

    def run_command_and_write_log(self, logfile_name, args):
        f_stdout = open(logfile_name + '.log', mode='w+')
        f_stderr = open(logfile_name + '.err', mode='w+')
        proc = subprocess.run(args, stdout=f_stdout, stderr=f_stderr)
        f_stdout.seek(0, os.SEEK_SET)
        f_stderr.seek(0, os.SEEK_SET)
        text_stdout = f_stdout.read()
        text_stderr = f_stderr.read()
        f_stderr.close()
        f_stdout.close()
        self.assertEqual(type(proc), subprocess.CompletedProcess, text_stderr)
        self.assertEqual(proc.returncode, 0, text_stderr)
        self.assertGreater(len(text_stdout.splitlines()), 0, text_stderr)
        return (text_stdout, text_stderr)

class TestUsrpMethods(TestCommon):

    def test_boot_kernel(self):

        def filter_known_fails(lines):
            pattern="^(reg-userspace-consumer db[01]_supply: Failed to get supplies: -517" \
                    "|dwc3 fe200000.usb: Failed to get clk 'ref': -2" \
                    "|OF: overlay: WARNING: memory leak will occur if overlay removed, property:.*)$"
            prog = re.compile(pattern)
            to_be_removed = []
            for (i,line) in enumerate(lines):
                if line.startswith('['):
                    # timestamp present, e.g. '[    0.000000] '
                    result = prog.match(line[15:])
                else:
                    # no timestamp resent
                    result = prog.match(line)
                if result:
                    # match found -> remove this line
                    to_be_removed.append(i)
            to_be_removed.reverse()
            for i in to_be_removed:
                lines.pop(i)
            return lines

        subprocess.call("dmesg -k > dmesg-kernel.txt", shell=True)
        i=0
        error_data=""
        for level in ["emerg", "alert", "crit", "err", "warn", "info", "notice"]:
            output = subprocess.check_output("dmesg -k --level={!s} | tee dmesg-kernel-{!s}-{!s}.txt".format(level, str(i), level), shell=True)
            lines = output.decode("utf-8").splitlines()
            if level in ["emerg", "alert", "crit", "err"]:
                lines = filter_known_fails(lines)
                error_data += "\n".join(lines)
            i=i+1
        self.assertEqual(len(error_data), 0, "\nboot issue: kernel errors in logfile: \n"+error_data)

    def test_boot_userspace(self):
        subprocess.call("dmesg -u > dmesg-userspace.txt", shell=True)
        i=0
        error_data=""
        for level in ["emerg", "alert", "crit", "err", "warn", "info", "notice"]:
            output = subprocess.check_output("dmesg -u --level={!s} | tee dmesg-userspace-{!s}-{!s}.txt".format(level, str(i), level), shell=True)
            if level in ["emerg", "alert", "crit", "err", "warn"]:
                error_data += output.decode("utf-8")
            i=i+1
        self.assertEqual(len(error_data), 0, "\nboot issue: userspace warnings/errors in logfile: \n"+error_data)

    def test_systemd_system_running(self):
        t = 0
        TIMESTEP = 0.5
        TIMEOUT = 30
        while t < TIMEOUT:
            subprocess.call("systemctl list-units > systemd.units", shell=True)
            try:
                output = subprocess.check_output("systemctl is-system-running --wait", shell=True).decode("utf-8").splitlines()[0]
            except subprocess.CalledProcessError as err:
                output = err.output.decode("utf-8").splitlines()[0]
            if (output == "starting"):
                time.sleep(TIMESTEP)
                t += TIMESTEP
                continue
            else:
                explaination = {
                    "starting": "system is still starting",
                    "degraded": "one (or more) service was started with errors"
                }
                self.assertEqual(output, "running", "\n systemd: " + explaination.get(output, "system is in unexpected state"))
                break

    # def test_systemd_usrp_hwd_active(self):
    #     service = "usrp-hwd"
    #     t = 0
    #     TIMESTEP = 0.5
    #     TIMEOUT = 30
    #     while t < TIMEOUT:
    #         try:
    #             output = subprocess.check_output("systemctl is-active {}".format(service), shell=True).decode("utf-8").splitlines()[0]
    #         except subprocess.CalledProcessError as err:
    #             output = err.output.decode("utf-8").splitlines()[0]
    #         if (output == "starting"):
    #             time.sleep(TIMESTEP)
    #             t += TIMESTEP
    #             continue
    #         else:
    #             self.assertEqual(output, "active", "\nsystemd: {}.service is not active".format(service))
    #             break

    def test_systemd_usrp_hwd_status(self, fail_on_warnings = False):
        service = "usrp-hwd"
        output = subprocess.check_output("journalctl -b -u {} --no-hostname | tee usrp-hwd.log".format(service), shell=True).decode("utf-8")
        with open("usrp-hwd.log") as f:
            output += f.read()
        error_messages = ""
        warnings = 0
        errors = 0
        service_starting = False
        service_started = False
        for line in output.splitlines():
            match = re.match("^\w{3} \d+ \d+\:\d+\:\d+ (\S+)\[\d+\]\: (.*)$", line)
            if match:
                systemd_module = match.group(1)
                systemd_message = match.group(2)
                if systemd_module == "systemd":
                    if systemd_message.startswith("Starting"):
                        service_starting = True
                    elif systemd_message.startswith("Started"):
                        service_started = True
                elif systemd_module == "usrp_hwd.py":
                    match = re.match("\[(\S+)\] \[(\S+)\] (.*)$", systemd_message)
                    if match:
                        module = match.group(1)
                        level = match.group(2)
                        message = match.group(3)
                        if (level == "WARNING") and fail_on_warnings:
                            error_messages += systemd_message+"\n"
                            warnings += 1
                        elif level == "ERROR":
                            error_messages += systemd_message+"\n"
                            errors += 1

        self.assertEqual(service_starting, True, "usrp-hwd: service was never started")
        if fail_on_warnings:
            self.assertEqual(warnings + errors, 0, "usrp-hwd: there were {} warnings and {} errors:\n".format(warnings, errors) + error_messages)
        else:
            self.assertEqual(errors, 0, "usrp-hwd: there were {} errors:\n".format(errors) + error_messages)
        self.assertEqual(service_started, True, "usrp-hwd: service never finished \"starting\" state")

    def test_uhd_usrp_probe(self):
        (text_stdout, text_stderr) = self.run_command_and_write_log('uhd_usrp_probe', \
            ['uhd_usrp_probe', '--args=addr=169.254.0.2,mgmt_addr=127.0.0.1'])
        errors = 0
        for line in text_stderr.splitlines():
            if line.startswith('[ERROR]'):
                errors += 1
        self.assertEqual(errors, 0, text_stderr)

    def test_network_up(self):
        interface = "eth0"
        output = subprocess.check_output(['ip', 'link', 'show', interface]).decode("utf-8")
        r = re.compile('^([0-9]): (\S*): <(\S*)> (.*)$')
        m = r.match(output.splitlines()[0])
        self.assertEqual(m[2], interface, 'Interface is not configured as expected:\n' + output)
        self.assertEqual(m[3], 'BROADCAST,MULTICAST,UP,LOWER_UP', 'Interface is not configured as expected:\n' + output)

    def test_network_resolve(self):
        output = subprocess.check_output("cat /etc/resolv.conf", shell=True).decode("utf-8")
        found_nameserver = False
        found_domain = False
        for line in output.splitlines():
            if line.startswith("nameserver"):
                nameserver = line[11:]
                found_nameserver = True
                self.assertNotEqual(nameserver, "8.8.8.8", "\nFound Google DNS server - this should not happen in company network")
                self.assertNotEqual(nameserver, "4.4.4.4", "\nFound Google DNS server - this should not happen in company network")
            if line.startswith("search") or line.startswith("domain"):
                domain = line[7:]
                found_domain = True
                ni_domain_configured = domain in [ "ni.corp.natinst.com", "amer.corp.natinst.com"]
                self.assertTrue(ni_domain_configured, "\nDomain is not ni.corp.natinst.com:\n"+output)
        self.assertTrue(found_nameserver,"\nresolv.conf: Did not find a DNS nameserver:\n"+output)
        self.assertTrue(found_domain, "\nresolv.conf: No domain (parameter \"search\" or \"domain\") was configured:\n"+output)

    def test_mpm_init_status(self):
        connected = False
        methods_added = 0
        command_executed = False
        proc = subprocess.run("echo \"get_init_status\" | mpm_shell.py -c localhost", shell=True, timeout=10, capture_output=True)
        self.assertEqual(type(proc), subprocess.CompletedProcess)
        output = proc.stdout.decode('utf-8').splitlines()
        for line in output:
            if line == "Connection successful.":
                connected = True
            m = re.match("Added (\d*) methods.", line)
            if m:
                methods_added = int(m.group(1))
            m = re.match("ni-.*-.* \[C\]> (<|==>) (.*)", line)
            if m:
                command_executed = True
                init_status = m.group(2)
        self.assertTrue(connected)
        self.assertGreater(methods_added, 0)
        self.assertTrue(command_executed)
        self.assertEqual(init_status, "('true', 'No errors.')")

    def test_sshd(self):
        user = "root"
        output = subprocess.check_output("ssh -o StrictHostKeyChecking=no {}@localhost echo success || echo failure".format(user), shell=True).decode("utf-8").splitlines()[0]
        self.assertEqual(output, "success", "Cannot connect via SSH to {}@localhost".format(user))

    def test_hostname(self):
        hostname = subprocess.check_output("hostnamectl --static status", shell=True).decode("utf-8").splitlines()[0]
        match = re.match("ni-{e31x|e320|n3xx|x4xx}-\w{7}", hostname)
        self.assertNotEqual(match, "None")

    def test_lsb_release(self):
        self.run_command_and_write_log('lsb_release', ['lsb_release', '-a'])

    def test_uhd_config_info(self):
        self.run_command_and_write_log('uhd_config_info', ['uhd_config_info', '--print-all'])

    def test_usb_detected(self):
        (output, _) = self.run_command_and_write_log('lsusb', ['lsusb'])
        # root@ni-x4xx-<serial>:~# lsusb
        # Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
        # Bus 001 Device 002: ID 0781:5597 SanDisk Corp.  SanDisk 3.2Gen1
        # Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
        num_of_devices = len(output.splitlines())
        self.assertGreater(num_of_devices, 2) # expect at least 3 entries.
        search_string = "USB Mass Storage device detected"
        output = subprocess.check_output("dmesg").decode("utf-8")
        self.assertTrue(search_string in output)

class TestGnuradio(TestCommon):

    @unittest.skipUnless(package_installed('gnuradio'), 'gnuradio is not installed')
    def test_gnuradio_version(self):
        expected_version = '3.8.0.0'
        version = subprocess.check_output(['gnuradio-config-info', '-v']).decode('utf-8').splitlines()[0]
        self.assertEqual(version, expected_version)

    @unittest.skipUnless(package_installed('gnuradio'), 'gnuradio is not installed')
    def test_gnuradio_gr_loadable(self):
        proc = subprocess.run(['python3', '-c', 'import gnuradio'])
        self.assertEqual(proc.returncode, 0)

if __name__ == '__main__':
    unittest.main()
