#!/bin/bash
#
# Copyright 2019 Ettus Research, a National Instruments Company
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Utility to loop-mount filesystem images
# it will create the mount points /mnt/boot, /mnt/primary, etc.

if [ -z "$1" ]
then
  echo "usage: $0 <image> [ro|rw]"
  exit 1
else
  IMAGE=$1
fi

OPTS="ro"
if [[ "$2" == "rw" ]]
then
  OPTS="rw"
fi

# === example output ===
#
#label: dos
#label-id: 0xe4b3a525
#device: oe-build/build/tmp-glibc/deploy/images/ni-sulfur-rev5/developer-image-ni-sulfur-rev5.sdimg
#unit: sectors
#
#oe-build/build/tmp-glibc/deploy/images/ni-sulfur-rev5/developer-image-ni-sulfur-rev5.sdimg1 : start=       49152, size=       32768, type=c, bootable
#oe-build/build/tmp-glibc/deploy/images/ni-sulfur-rev5/developer-image-ni-sulfur-rev5.sdimg2 : start=       81920, size=    15347712, type=83
#oe-build/build/tmp-glibc/deploy/images/ni-sulfur-rev5/developer-image-ni-sulfur-rev5.sdimg3 : start=    15433728, size=    15347712, type=83
#oe-build/build/tmp-glibc/deploy/images/ni-sulfur-rev5/developer-image-ni-sulfur-rev5.sdimg4 : start=    30785536, size=      262144, type=83

sfdisk -ld $IMAGE | while read LINE;
do
  MATCH=$(echo "$LINE" | grep -e "^$IMAGE")
  if [ ! -z "$MATCH" ]
  then
    let i=i+1
    case $i in
      1) NAME=boot;;
      2) NAME=primary;;
      3) NAME=secondary;;
      4) NAME=data;;
      *) NAME="unknown$i";;
    esac
    let START=512*$(echo "$MATCH" | sed -n "s/.*start\=\s*\([0-9][0-9]*\).*/\1/p")
    let SIZE=512*$(echo "$MATCH" | sed -n "s/.*size\=\s*\([0-9][0-9]*\).*/\1/p")
    echo "mounting partition $i to /mnt/$NAME"
    sudo mkdir -p /mnt/$NAME && sudo mount -o loop,offset=$START,sizelimit=$SIZE,$OPTS $IMAGE /mnt/$NAME
  fi
done
