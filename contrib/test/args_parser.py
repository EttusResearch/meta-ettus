#!/usr/bin/env python3

import sys
import getopt
from os.path import dirname, realpath


def print_usage(script):
    print('usage: {} [-c <configfile>] [-s <sourcedir>] [-t <devicetype>] '.format(script))


def parse_args(argv):
    config = {
        "devicetype": 'default',
        "configfile": '',
        "sourcedir": realpath(dirname(__file__)),
    }
    try:
        opts, args = getopt.getopt(argv[1:], "hc:s:t:", ["configfile=", "sourcedir=", "devicetype="])
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

    if config["configfile"] == '':
        config["configfile"] = config["sourcedir"] + '/config.conf'
    return config


def main(argv):
    parsed_args = parse_args(argv)
    print(parsed_args)


if __name__ == "__main__":
    main(sys.argv)
