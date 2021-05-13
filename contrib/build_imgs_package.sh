#!/bin/bash
#
# Copyright 2018 Ettus Research, a National Instruments Company
# Copyright 2019 Ettus Research, a National Instruments Brand
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Utility to build images packages for delivering via to uhd_images_downloader

META_ETTUS_DIR=$(dirname $(readlink -f $0))/..
SETUP_ENV_SH=$META_ETTUS_DIR/contrib/setup_build_env.sh
TMP_OUTPUT_DIR=tmp-glibc

if [ ! -r $SETUP_ENV_SH ]; then
	echo "ERROR: This needs to be run from the Ettus OE root."
	exit 1
fi

if [[ $# -eq 0 ]]; then
	echo "Usage: $0 device_type artifact_name"
	echo ""
	echo "Arguments:"
	echo "- device_type: The name of the device that is being targeted (e.g. 'n3xx')"
	echo "- artifact_name: The artifact name that gets stored on the filesystem (e.g. 'v3.13.0.2')"
	echo "- src_dir: The directory in which the layers are stored (defaults to the \$HOME directory)"
	echo "- build_dir: The directory in which builds happen (defaults to \$src_dir/build)"
	exit 0
fi

_requested_device=$1
_artifact_name="git"
if [[ $# -ge 2 ]]; then
	_artifact_name=$2
fi
_src_dir=$HOME
if [[ $# -ge 3 ]]; then
	_src_dir=$3
fi

_build_dir=$_src_dir/build
if [[ $# -ge 4 ]]; then
	_build_dir=$4
fi

_image=gnuradio-image

echo "Sourcing environment..."
source $SETUP_ENV_SH $_requested_device $_artifact_name $_src_dir $_build_dir

## SD Card Image #########################################################
echo "Launching build ($_image)..."
bitbake $_image
if [ $? != 0 ]; then
	echo "Build was not successful, stopping script"
	exit 1
fi

## SDK ################################################################
if [ ! -z $_sdk_pkg_name ]; then
	echo "Launching build (SDK for $_image)..."
	bitbake $_image -cpopulate_sdk
fi

$META_ETTUS_DIR/contrib/create_packages.sh $_requested_device $_build_dir/deploy $_image $_build_dir/deploy
