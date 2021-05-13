#!/bin/bash
#
# Copyright 2021 Ettus Research, a National Instruments Brand
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Utility to build images packages for delivering via to uhd_images_downloader using kas

META_ETTUS_DIR=$(dirname $(readlink -f $0))/..

if [[ $# -eq 0 ]]; then
	echo "Usage: $0 device_type artifact_name"
	echo ""
	echo "Arguments:"
	echo "- device_type: The name of the device that is being targeted (e.g. 'n3xx')"
	echo "- artifact_name: The artifact name that gets stored on the filesystem (e.g. 'v3.13.0.2')"
	exit 0
fi

_requested_device=$1
_kas_config=$META_ETTUS_DIR/kas/$_requested_device.yml

_artifact_name="git"
if [[ $# -ge 2 ]]; then
	_artifact_name=$2
fi

_image=gnuradio-image

## SD Card Image #########################################################

export MENDER_ARTIFACT_NAME=$_artifact_name

echo "Launching build ($_image)..."
kas build $_kas_config
if [ $? != 0 ]; then
	echo "Build was not successful, stopping script"
	exit 1
fi

## SDK ################################################################
if [ ! -z $_sdk_pkg_name ]; then
	echo "Launching build (SDK for $_image)..."
	kas shell $_kas_config -c "bitbake $_image -cpopulate_sdk"
fi

$META_ETTUS_DIR/contrib/create_packages.sh $_requested_device $_build_dir/deploy $_image $_build_dir/deploy
