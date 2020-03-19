#!/usr/bin/env python3

import sys
import getopt
from os.path import dirname, realpath


def print_usage(script):
    print('usage: {} [-c <configfile>] [-s <sourcedir>] [-t <devicetype>] [-p <pythondeps>] [-e <execcmd>] [-f <testfolder>] [-b <bitfile>] [-a <localaddress>]'.format(script))


def parse_args(argv):
    config = {
        "devicetype": 'default',
        "configfile": '',
        "sourcedir": realpath(dirname(__file__)),
    }
    try:
        opts, args = getopt.getopt(argv[1:], "hc:s:t:p:e:f:b:a:",
                                   ["configfile=", "sourcedir=", "devicetype=", "pythondeps=",
                                     "execcmd=", "testfolder=", "bitfile=", "addr=",
                                    "args="])
    except getopt.GetoptError:
        print_usage(argv[0])
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print_usage(argv[0])
            sys.exit()
        elif opt in ("-c", "--configfile"):
            config["configfile"] = arg
        elif opt in ("-t", "--type"):
            config["devicetype"] = arg
        elif opt in ("-s", "--sourcedir"):
            config["sourcedir"] = arg
        elif opt in ("-p", "--pythondeps"):
            config["pythondeps"] = arg
        elif opt in ("-e", "--execcmd"):
            config["cmd"] = arg
        elif opt in ("-f", "--testfolder"):
            config["testfolder"] = arg
        elif opt in ("-b", "--bitfile"):
            config["bitfile"] = arg
        elif opt in ("-a", "--addr"):
            config["addr"] = arg
        elif opt in ("--args"):
            config["args"] = arg

    if config["configfile"] == '':
        config["configfile"] = config["sourcedir"] + '/config.conf'
    return config


def main(argv):
    parsed_args = parse_args(argv)
    print(parsed_args)


if __name__ == "__main__":
    main(sys.argv)
