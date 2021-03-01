#!/usr/bin/env python3

import sys
import configparser

def parse_config(file):
    configparser1 = configparser.RawConfigParser()
    configparser1.read(file)
    requiredargs = ["ZYNQ_UART", "STM_UART"]
    return configparser1
