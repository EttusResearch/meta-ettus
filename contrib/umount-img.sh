#!/bin/bash
#
# Copyright 2019 Ettus Research, a National Instruments Company
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Utility to unmount the mount points created by mount-img.sh

MOUNTPOINTS="/mnt/boot /mnt/primary /mnt/secondary /mnt/data"

for MOUNTPOINT in $MOUNTPOINTS; do
  if [ -d $MOUNTPOINT ]; then
    echo "unmounting $MOUNTPOINT"
    sudo umount $MOUNTPOINT && sudo rmdir $MOUNTPOINT
  fi
done
