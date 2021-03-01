import re
import sys

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


def check_required_params(params, config, device_type):
    if device_type not in config:
        msg = "Error: section {} (equivalent to devicetype) not found in configuration file"
        raise RuntimeError(msg.format(device_type))

    for param in params:
        if param not in config[device_type]:
            msg = "Error: required parameter {} was not configured in configuration file (section {})"
            raise RuntimeError(msg.format(param, device_type))


def update_config(config, parsed_config, device_type):
    for param,current_value in config.items():
        if param in parsed_config[device_type]:
            if isinstance(current_value, str):
                config[param] = parsed_config.get(device_type, param)
            elif isinstance(current_value, int):
                config[param] = parsed_config.getint(device_type, param)
            elif isinstance(current_value, float):
                config[param] = parsed_config.getfloat(device_type, param)
            elif isinstance(current_value, bool):
                config[param] = parsed_config.getboolean(device_type, param)
            else:
                print("unsupported param type: type(config['{}'])={}".format( \
                    param, type(current_value)))
                sys.exit(2)
    return config
