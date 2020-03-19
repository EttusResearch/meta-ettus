#!/usr/bin/env python3

import sys
import configparser

def parse_config(file, device_type):
    conf = configparser.RawConfigParser()
    conf.read(file)

    if device_type not in conf:
        raise RuntimeError("Error: section {} (equivalent to devicetype) not found in configuration file {}".format(device_type, file))

    return conf[device_type]
