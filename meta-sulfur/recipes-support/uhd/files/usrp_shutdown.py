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
from usrp_mpm.sys_utils.i2c_dev import dt_symbol_get_i2c_bus

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
    return ''


def main():
    """
    Main function
    """
    db_id = get_dboard_id_from_eeprom(['rhodium'])
    if 'rhodium' not in db_id:
        exit()
    get_main_logger()
    dtoverlay.apply_overlay_safe('n320')
    i2c_bus = dt_symbol_get_i2c_bus("usrpio_i2c0")
    if i2c_bus is None:
        print("error: Failed to resolve I2C bus")
        sys.exit(1)
    if not FPGAtoLoDist.lo_dist_present(i2c_bus):
        print("error: LO distribution board not found")
        sys.exit(1)
    lodist = FPGAtoLoDist(i2c_bus)
    lodist.reset('P3_3V_RF_EN')
    lodist.reset('P6_5V_LDO_EN')
    lodist.reset('P6_8V_EN')

if __name__ == '__main__':
    main()
