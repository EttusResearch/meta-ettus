#!/bin/bash
#
# Copyright 2019 Ettus Research, a National Instruments Brand
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

# This script uses bmaptool (version 3.5 or later) to flash the filesystem archive
# (.zip file) which contains the .sdimg and the corresponding .bmap file

# Step 1: check arguments

if [ $# -ne 2 ]; then
  echo "usage: $0 image dest"
  echo "where image is a .zip containing the .sdimg and .sdimg.bmap files"
  echo "and dest is the destination (typically block device) to write to"
  exit 0
fi

IMAGE=$1
DEST=$2

if [ "$(basename $IMAGE .zip)" = "$IMAGE" ]; then
  echo "ERROR: <image> must be a .zip file"
  exit 1
fi

# Step 2: check dependencies

which unzip > /dev/null
if [ $? -ne 0 ]; then
  echo "ERROR: this script requires unzip to be installed"
  exit 1
fi

which bmaptool > /dev/null
if [ $? -ne 0 ]; then
  echo "ERROR: this script requires bmaptool (version 3.5 or later) to be installed"
  exit 1
fi

# Step 3: check the contents of the .zip file

if [ ! -r $IMAGE ]; then
  echo "ERROR: cannot read $IMAGE"
  exit 1
fi

SDIMG=$(unzip -l $IMAGE "*.sdimg" | grep -e "\S*\.sdimg" -o)
BMAP=$(unzip -l $IMAGE "*.bmap" | grep -e "\S*\.bmap" -o)

if [ -z "$SDIMG" ]; then
  echo "ERROR: $IMAGE does not contain a .sdimg file"
  exit 1
fi

if [ -z "$BMAP" ]; then
  echo "ERROR: $IMAGE does not contain a .bmap file"
  exit 1
fi

# Step 4: create a temp folder and extract the files
# (the .sdimg file is written to a FIFO and consumed by bmaptool at the same
# time so that it does not require extra space on the file system)

TMP_DIR=$(mktemp -d)

unzip -d "$TMP_DIR" "$IMAGE" "$BMAP"
mkfifo "$TMP_DIR/$SDIMG"
unzip -p "$IMAGE" "$SDIMG" > "$TMP_DIR/$SDIMG" &
echo "Archive:  $IMAGE"
echo "  inflating: $TMP_DIR/$SDIMG (as fifo)"

# Step 5: flash the image using bmaptool

bmaptool copy --bmap "$TMP_DIR/$BMAP" "$TMP_DIR/$SDIMG" "$DEST"

# Step 6: remove the temp folder

rm -rf "$TMP_DIR"
