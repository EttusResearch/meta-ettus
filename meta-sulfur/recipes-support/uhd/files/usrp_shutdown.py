#!/usr/bin/env python3
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Copyright 2019 National Instruments Corp
#

"""
Script to turn off the regulators on N321's LO distribution board
"""
import subprocess
import pyudev
from usrp_mpm.mpmlog import get_main_logger
from usrp_mpm.dboard_manager.rh_periphs import FPGAtoLoDist
from usrp_mpm.sys_utils import dtoverlay

def get_dboard_id_from_eeprom(valid_ids):
    """
    Return the bboard product ID

    Returns something like magnesium, rhodium...
    """
    cmd = ['db-id']
    output = subprocess.check_output(
        cmd,
        stderr=subprocess.STDOUT,
        shell=True,
    ).decode('utf-8')
    for valid_id in valid_ids:
        if valid_id in output:
            return valid_id
    return None


def main():
    """
    Main function
    """
    db_id = get_dboard_id_from_eeprom(['rhodium'])
    if 'rhodium' not in db_id:
        exit()
    logger = get_main_logger()
    dtoverlay.apply_overlay_safe('n320')
    context = pyudev.Context()
    adapter = pyudev.Devices.from_sys_path(context, '/sys/class/i2c-adapter/i2c-9')
    lodist = FPGAtoLoDist(adapter)
    lodist.reset('P3_3V_RF_EN')
    lodist.reset('P6_5V_LDO_EN')
    lodist.reset('P6_8V_EN')

if __name__ == '__main__':
    main()
