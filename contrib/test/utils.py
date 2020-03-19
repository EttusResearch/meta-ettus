import os
import netifaces
import psutil
import subprocess
import sys
import re
import config_parser

from args_parser import parse_args
from os.path import expanduser
from tempfile import mktemp

# 7-bit C1 ANSI sequences
ansi_escape = re.compile(r'''
    \x1B    # ESC
    [@-_]   # 7-bit C1 Fe
    [0-?]*  # Parameter bytes
    [ -/]*  # Intermediate bytes
    [@-~]   # Final byte
''', re.VERBOSE)

# 7-bit C1 ANSI sequences
ansi_escape2 = re.compile(r'''
    \x1B    # ESC
    [0-9]   # ???
''', re.VERBOSE)

# Non ASCII characters
non_ascii = re.compile(r'''
    [\x00-\0x1F]    # non-ascii characters
''', re.VERBOSE)


def remove_ansi(text):
    return ansi_escape.sub('', text)


def remove_ansi2(text):
    return ansi_escape2.sub('', text)


def remove_non_ascii(text):
    return non_ascii.sub('', text)


def get_ip_addr_from_log(log_file):
    ip = ''
    with open(log_file, "r") as f:
        while True:
            line = f.readline()

            if len(line) > 0:
                #print(line, end='')
                # "[    8.618083] IP-Config: Got DHCP answer from W.X.Y.Z, my address is W.X.Y.Z"
                # "[    5.607082] IP-Config: Got DHCP answer from W.X.Y.Z, my address is W.X.Y.Z"
                #match = re.match("^IP-Config: Got DHCP answer from \d+\.\d+\.\d+\.\d+, my address is (\d+\.\d+\.\d+\.\d+)$", line[15:])
                match = re.match(".*inet addr:(\d+\.\d+\.\d+\.\d+).*", line)
                if match:
                    ip = match.group(1)
                    break
            else:
                break

    return ip


def get_target_ip(config):
    # First see if a targetip has been specified, if not, parse it from the log
    ip = config.get('targetip')
    if ip is not None and len(ip) != 0:
        return ip

    required_params = ["boot_logfile"]
    check_required_params(required_params, config)
    ip = get_ip_addr_from_log(config['boot_logfile'])

    if len(ip) == 0:
        raise RuntimeError("unable to determine target IP address!")


def get_host_ip():
    gw_iface = netifaces.gateways()['default'][netifaces.AF_INET][1]
    if not gw_iface:
        raise RuntimeError("Error: could auto-detect default gateway")
    serverip = netifaces.ifaddresses(gw_iface)[netifaces.AF_INET][0]['addr']
    if not serverip:
        raise RuntimeError("Error: could auto-detect serverip")
    return serverip


def check_required_params(params, config):
    for param in params:
        if param not in config:
            msg = "Error: required parameter {} was not configured in configuration file (section {})"
            raise RuntimeError(msg.format(param, config.name))


def update_config(config, parsed_config):
    for param,current_value in config.items():
        if param in parsed_config:
            if isinstance(current_value, str):
                config[param] = parsed_config.get(param)
            elif isinstance(current_value, int):
                config[param] = parsed_config.getint(param)
            elif isinstance(current_value, float):
                config[param] = parsed_config.getfloat(param)
            elif isinstance(current_value, bool):
                config[param] = parsed_config.getboolean(param)
            else:
                msg = "unsupported param type: type(config['{}'])={}".format( \
                    param, type(current_value))
                raise RuntimeError(msg)
    return config

def update_config_with_args(config, args):
    pairs = args.split(',')
    for pair in pairs:
        k_v = pair.strip().split('=')
        key = k_v[0]
        value = k_v[1]
        config[key] = value
    return config

def get_config(argv):

    def _get_uhd_type(parsed_args):
        if 'devicetype' in parsed_args:
            return parsed_args['devicetype'].split('-')[0]
        else:
            return None

    parsed_args = parse_args(argv)

    config = {
        'default_timeout': 0.2,
        'boot_timeout': 12,
        'poweroff_timeout': 12,
        'boot_logfile': 'boot.log',
        'fit_image': '/boot/fitImage',
        'test_src_folder': parsed_args['sourcedir'],
        'sourcedir': parsed_args['sourcedir'],
        'tests_folder': parsed_args.get('testfolder', 'tests'),
        'tests_deps': parsed_args.get('pythondeps', 'unittest-xml-reporting'),
        'tests_command': parsed_args.get('cmd', 'python3 -m xmlrunner discover . -v'),
        'test_dst_folder': '~/usrp_test',
        'mpm_test_folder': '~/mpm_test_run',
        'devtests_test_folder': '~/devtests_test_run',
        'serverip': get_host_ip(),
        'rio_tests_folder': 'rio_tests',
        'addr': parsed_args.get('addr', '127.0.0.1'),
        'uhd_type': parsed_args.get('devicetype', 'unknown').split('-')[0],
        'bitfile': parsed_args.get('bitfile', 'unknown'),
    }

    parsed_config = config_parser.parse_config(parsed_args['configfile'], parsed_args['devicetype'])

    # First, update any defaults. This ensures the type is correct.
    update_config(config, parsed_config)

    # Now, update any keys from the file. This will add the value as a string
    # If you need a bool/int/float, add it as a default to config above
    for k, v in parsed_config.items():
        if k not in config:
            config[k] = v

    if 'args' in parsed_args:
        update_config_with_args(config, parsed_args['args'])

    # first try to get the IP from the environment
    if 'USRP_EMB_TARGET_IP' in os.environ:
        config['targetip'] = os.environ['USRP_EMB_TARGET_IP']

    # this can't be part of the defaults, since it needs the value of boot_logfile
    if 'targetip' not in config:
        try:
            config['targetip'] = get_ip_addr_from_log(config['boot_logfile'])
        except FileNotFoundError:
            print("Could not determine Target IP adress (parameter 'targetip')"
                  "because boot logfile ('{}') was not found".format(
                  config['boot_logfile']))

    return config

def run_command(cmd, stdout=None, stderr=None):
    print("running command: ", cmd, flush=True)
    return subprocess.run(cmd, stdout=stdout, stderr=stderr).returncode


def delete_ssh_key(ip):
    run_command(['ssh-keygen', '-f', expanduser("~")+'/.ssh/known_hosts', '-R', ip])

def get_processes_accessing_file(filename):
    """ get the processes which accesses a file """
    proc = subprocess.run(['fuser', filename], stdout=subprocess.PIPE,
                          stderr=subprocess.DEVNULL, check=False)
    if proc.returncode != 0:
        return None
    pids = [int(x) for x in proc.stdout.decode('utf-8').strip().split(' ')]
    processes = [psutil.Process(pid) for pid in pids]
    return processes

def process_callstack(proc, sameuser=False, maxlevel=-1):
    """ return the process callstack (list of process and parent process(es)) """
    processes = []
    username = proc.username()
    level = 1
    while proc is not None:
        if sameuser and (proc.username() != username):
            break
        if (maxlevel > 0) and (level > maxlevel):
            break
        processes.append(proc)
        proc = proc.parent()
        level += 1
    return processes

def get_callstack(processes):
    """ print the callstack (list of processes) """
    if len(processes)==0:
        return None
    callstack = []
    callstack.append('PID\tcommand')
    for i,proc in enumerate(processes):
        if i==1:
            callstack.append("called by:")
        callstack.append("{}:\t{}".format(proc.pid, proc.cmdline()))
    return callstack

def check_open_filehandles(filename):
    """ Check if a file is already opened by another process. If this is the case,
    generate a RuntimeError which includes the callstack for this process """
    processes = get_processes_accessing_file(filename)
    if processes is None:
        return
    error = f'File {filename} is already opened by the following process(es):\n'
    for process in processes:
        callstack = process_callstack(process, sameuser=True)
        callstack_text = get_callstack(callstack)
        error += '\n'.join(callstack_text)
    raise RuntimeError(error)

class Ssh:
    def __init__(self, user, host):
        self.addr = "{user}@{host}".format(user=user, host=host)
        delete_ssh_key(host)

    def unchecked_exec(self, cmd, stdout=None, stderr=None):
        opts = '-o StrictHostKeyChecking=no'
        ssh_opts = '-tt'
        if isinstance(cmd, str):
            cmd = [cmd]
        return run_command(['ssh', opts, ssh_opts, self.addr] + cmd,
                stdout=stdout, stderr=stderr)

    def exec(self, cmd, stdout=None, stderr=None):
        ret = self.unchecked_exec(cmd, stdout, stderr)
        if ret != 0:
            raise RuntimeError('exec of "{cmd}" on {addr} failed!'.format(cmd=cmd, addr=self.addr))

    def copy(self, src, dst):
        opts = '-o StrictHostKeyChecking=no'
        ret = run_command(['scp', opts, '-r', '{addr}:{src}'.format(addr=self.addr, src=src), dst])
        if ret != 0:
            raise RuntimeError('copy of {src} from {addr} to {dst} failed!'.format(src=src, addr=self.addr, dst=dst))

    def copy_to(self, src, dst):
        opts = '-o StrictHostKeyChecking=no'
        ret = run_command(['scp', opts, '-r', src, '{addr}:{dst}'.format(addr=self.addr, dst=dst)])
        if ret != 0:
            raise RuntimeError('copy of {src} to {dst} on {addr} failed!'.format(src=src, addr=self.addr, dst=dst))

    def put_text(self, text, dst):
        """ Put the text into a dstfile on the remote target """
        local_path = mktemp()
        with open(local_path, 'w') as f:
            f.write(text)
        self.copy_to(local_path, dst)
        os.remove(local_path)

    def get_text(self, src):
        """ Get the text from a file on the remote target """
        local_path = mktemp()
        self.copy(src, local_path)
        with open(local_path, 'r') as f:
            text = f.read()
            if type(text) is not str:
                text = text.decode('utf-8')
        os.remove(local_path)
        return text

    def run_script(self, script):
        # not guaranteed to be unique on the remote...
        remote_path = mktemp()

        self.put_text(script, remote_path)
        self.exec(['/bin/bash', remote_path])

    def background_run_script(self, script):
        # not guaranteed to be unique on the remote...
        remote_path = mktemp()

        self.put_text(script, remote_path)
        self.background_exec(['/bin/bash', remote_path])
