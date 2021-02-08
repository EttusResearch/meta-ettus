#!/usr/bin/env python3

from pathlib import Path


class Ftdi:
    def __init__(self, serial):
        self.serial = serial

    def get_uart(self, port):
        base = Path('/dev/serial/by-id')
        for port in base.glob(f'*{self.serial}*if*{port}*'):
            return str(port)
        raise RuntimeError('could not find serial port')
