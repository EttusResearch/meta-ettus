#!/bin/bash
#
# Copyright 2018 Ettus Research, a National Instruments Company
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Utility to build images packages for delivering via to uhd_images_downloader

SETUP_ENV_SH=meta-ettus/contrib/setup_build_env.sh
TMP_DIR=ettus_tmp
DST_DIR=.

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
	echo "- build_dir: The directory in which builds happen (defaults to \$HOME/build)"
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
case $_requested_device in
	"n3xx")
		echo "Building N3x0 image..."
		_sdimg_file_name=usrp_n3xx_fs.sdimg
		_mender_file_name=usrp_n3xx_fs.mender
		_sdimg_pkg_name=n3xx_common_sdimg_default-$_artifact_name.zip
		_mender_pkg_name=n3xx_common_mender_default-$_artifact_name.zip
		_sdk_pkg_name=n3xx_common_sdk_default-$_artifact_name.zip
	;;
	"e320")
		echo "Building E320 image..."
		_sdimg_file_name=usrp_e320_fs.sdimg
		_mender_file_name=usrp_e320_fs.mender
		_sdimg_pkg_name=e3xx_e320_sdimg_default-$_artifact_name.zip
		_mender_pkg_name=e3xx_e320_mender_default-$_artifact_name.zip
		_sdk_pkg_name=e3xx_e320_sdk_default-$_artifact_name.zip
	;;
	*)
		echo "Unknown device type: $_requested_device. Aborting."
		exit 1
	;;
esac

echo "Sourcing environment..."
source $SETUP_ENV_SH $_requested_device $_artifact_name $_src_dir $_build_dir

## SD Card Image #########################################################
echo "Launching build (image)..."
bitbake developer-image
echo "Finding image..."
_sdimg=`find tmp-glibc/deploy/images -name "developer-image*.sdimg" -type l`
if [ ! -r $_sdimg ]; then
	echo "ERROR: Could not find SD card image!" exit 1
fi
echo "Copying SD card image to tmp dir..."
mkdir -p $TMP_DIR
cp -v $_sdimg $TMP_DIR/$_sdimg_file_name
if [ -r $_sdimg.bmap ]; then
	cp -v $_sdimg.bmap $TMP_DIR/$_sdimg_file_name.bmap
fi
echo "Zipping up SD image package..."
(cd $TMP_DIR; zip $_sdimg_pkg_name *)
mv $TMP_DIR/*.zip $DST_DIR
rm $TMP_DIR/*

## Mender Image #########################################################
# This gets built in the same step as the SD card image.
echo "Finding mender artefact..."
_mender_art=`find tmp-glibc/deploy/images -name "developer-image*.mender" -type l`
if [ ! -r $_mender_art ]; then
	echo "ERROR: Could not find mender artefact!"
	exit 1
fi
echo "Copying mender artefact to tmp dir..."
mkdir -p $TMP_DIR
cp -v $_mender_art $TMP_DIR/$_mender_file_name
echo "Zipping up mender artefact..."
(cd $TMP_DIR; zip $_mender_pkg_name *.mender)
mv $TMP_DIR/*.zip $DST_DIR
rm $TMP_DIR/*

## SDK ################################################################
echo "Launching build (SDK)..."
bitbake developer-image -cpopulate_sdk
echo "Finding SDK..."
_sdk=`find tmp-glibc/deploy/sdk -name "oecore*.sh" -type f`
if [ ! -r $_sdk ]; then
	echo "ERROR: Could not find SDK!"
	exit 1
fi
_sdkpath=`dirname $_sdk`
echo "Found SDK in: $_sdkpath. Files:"
ls $_sdkpath
# SDK works a bit differently. We just zip up the SDK directory.
echo "Zipping up SDK..."
zip -j $TMP_DIR/$_sdk_pkg_name $_sdkpath/*.{sh,manifest,json}
mv $TMP_DIR/*.zip $DST_DIR

rmdir $TMP_DIR

