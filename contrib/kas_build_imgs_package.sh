#!/bin/bash
#
# Copyright 2021 Ettus Research, a National Instruments Brand
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Utility to build images packages for delivering via to uhd_images_downloader using kas

TMP_DIR=ettus_tmp
DST_DIR=.
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

case $_requested_device in
	"n3xx")
		echo "Building N3x0 image..."
		_sdimg_file_name=usrp_n3xx_fs.sdimg
		_mender_file_name=usrp_n3xx_fs.mender
		_sdimg_pkg_name=n3xx_common_sdimg_default-$_artifact_name.zip
		_mender_pkg_name=n3xx_common_mender_default-$_artifact_name.zip
		_sdk_pkg_name=n3xx_common_sdk_default-$_artifact_name.zip
		_device=sulfur
	;;
	"e320")
		echo "Building E320 image..."
		_sdimg_file_name=usrp_e320_fs.sdimg
		_mender_file_name=usrp_e320_fs.mender
		_sdimg_pkg_name=e3xx_e320_sdimg_default-$_artifact_name.zip
		_mender_pkg_name=e3xx_e320_mender_default-$_artifact_name.zip
		_sdk_pkg_name=e3xx_e320_sdk_default-$_artifact_name.zip
		_device=neon
	;;
	"e310_sg1")
		echo "Building E310 SG1 image..."
		_sdimg_file_name=usrp_e310_fs.sdimg
		_mender_file_name=usrp_e310_fs.mender
		_sdimg_pkg_name=e3xx_e310_sg1_sdimg_default-$_artifact_name.zip
		_mender_pkg_name=e3xx_e310_sg1_mender_default-$_artifact_name.zip
		_device=e31x-sg1
	;;
	"e310_sg3")
		echo "Building E310 SG3 image..."
		_sdimg_file_name=usrp_e310_fs.sdimg
		_mender_file_name=usrp_e310_fs.mender
		_sdimg_pkg_name=e3xx_e310_sg3_sdimg_default-$_artifact_name.zip
		_mender_pkg_name=e3xx_e310_sg3_mender_default-$_artifact_name.zip
		_sdk_pkg_name=e3xx_e310_sdk_default-$_artifact_name.zip
		_device=e31x-sg3
	;;
	"x4xx")
		echo "Building X4xx image..."
		_sdimg_file_name=usrp_x4xx_fs.sdimg
		_mender_file_name=usrp_x4xx_fs.mender
		_sdimg_pkg_name=x4xx_common_sdimg_default-$_artifact_name.zip
		_mender_pkg_name=x4xx_common_mender_default-$_artifact_name.zip
		_sdk_pkg_name=x4xx_common_sdk_default-$_artifact_name.zip
		_device=titanium
	;;
	*)
		echo "Unknown device type: $_requested_device. Aborting."
		exit 1
	;;
esac

## SD Card Image #########################################################

export MENDER_ARTIFACT_NAME=$_artifact_name

echo "Launching build ($_image)..."
kas build $_kas_config
if [ $? != 0 ]
then
	echo "Build was not successful, stopping script"
	exit 1
fi
echo "Finding image..."
_deploy_dir=$(kas shell -k $_kas_config -c "bitbake -e | grep ^DEPLOY_DIR=" | grep DEPLOY_DIR | sed -e 's/\S*=//' -e 's/"//g')
_sdimg=`find $_deploy_dir/images -name "$_image-ni-$_device*-mender.sdimg" -type l`
if [ ! -r $_sdimg ]; then
	echo "ERROR: Could not find SD card image!" exit 1
fi
echo "Found SD card image: $_sdimg"
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
echo "Finding mender artifact..."
_mender_art=`find $_deploy_dir/images -name "$_image-ni-$_device*-mender.mender" -type l`
if [ ! -r $_mender_art ]; then
	echo "ERROR: Could not find mender artifact!"
	exit 1
fi
echo "Found mender artifact: $_mender_art"
echo "Copying mender artifact to tmp dir..."
mkdir -p $TMP_DIR
cp -v $_mender_art $TMP_DIR/$_mender_file_name
echo "Zipping up mender artifact..."
(cd $TMP_DIR; zip $_mender_pkg_name *.mender)
mv $TMP_DIR/*.zip $DST_DIR
rm $TMP_DIR/*

## SDK ################################################################
# Skip SDK build for e310_sg1 as it has the same sdk as sg3.
if [ ! -z $_sdk_pkg_name ]; then
echo "Launching build (SDK for $_image)..."
kas shell $_kas_config -c "bitbake $_image -cpopulate_sdk"
echo "Finding SDK..."
_sdk=`find $_deploy_dir/sdk -name "oecore*.sh" -type f`
if [ ! -r $_sdk ]; then
	echo "ERROR: Could not find SDK!"
	exit 1
fi
echo "Found SDK: $_sdk"
_sdkpath=`dirname $_sdk`
echo "Found SDK in: $_sdkpath. Files:"
ls $_sdkpath
# Prefix all files with device
for f in `ls $_sdkpath`
do
	_base=`basename $f`
	cp -v $_sdkpath/$_base $TMP_DIR/$_requested_device-$_base
done
echo "Zipping up SDK..."
zip -j $TMP_DIR/$_sdk_pkg_name $TMP_DIR/*.{sh,manifest,json}
mv $TMP_DIR/*.zip $DST_DIR
rm $TMP_DIR/*
fi

rmdir $TMP_DIR
