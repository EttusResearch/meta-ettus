#!/bin/bash
#
# Copyright 2021 Ettus Research, a National Instruments Brand
#
# SPDX-License-Identifier: GPL-3.0-or-later

TMP_DIR=ettus_tmp
DST_DIR=.

if [[ $# -ne 4 ]]; then
	echo "Usage $0 device_type artifact_name deploy_dir"
	echo "Arguments:"
	echo "- device_type: The name of the device that is being targeted (e.g. 'n3xx')"
	echo "- artifact_name: The artifact name that gets stored on the filesystem (e.g. 'v3.13.0.2')"
	echo "- image_name: The name of the image built"
	echo "- deploy_dir: path to the deploy directory"
	exit 0
fi

_requested_device=$1
_artifact_name=$2
_image=$3
_deploy_dir=$4

case $_requested_device in
	"n3xx")
		_sdimg_file_name=usrp_n3xx_fs.sdimg
		_mender_file_name=usrp_n3xx_fs.mender
		_sdimg_pkg_name=n3xx_common_sdimg_default-$_artifact_name.zip
		_mender_pkg_name=n3xx_common_mender_default-$_artifact_name.zip
		_sdk_pkg_name=n3xx_common_sdk_default-$_artifact_name.zip
		_device=sulfur
	;;
	"e320")
		_sdimg_file_name=usrp_e320_fs.sdimg
		_mender_file_name=usrp_e320_fs.mender
		_sdimg_pkg_name=e3xx_e320_sdimg_default-$_artifact_name.zip
		_mender_pkg_name=e3xx_e320_mender_default-$_artifact_name.zip
		_sdk_pkg_name=e3xx_e320_sdk_default-$_artifact_name.zip
		_device=neon
	;;
	"e310_sg1")
		_sdimg_file_name=usrp_e310_fs.sdimg
		_mender_file_name=usrp_e310_fs.mender
		_sdimg_pkg_name=e3xx_e310_sg1_sdimg_default-$_artifact_name.zip
		_mender_pkg_name=e3xx_e310_sg1_mender_default-$_artifact_name.zip
		_device=e31x-sg1
	;;
	"e310_sg3")
		_sdimg_file_name=usrp_e310_fs.sdimg
		_mender_file_name=usrp_e310_fs.mender
		_sdimg_pkg_name=e3xx_e310_sg3_sdimg_default-$_artifact_name.zip
		_mender_pkg_name=e3xx_e310_sg3_mender_default-$_artifact_name.zip
		_sdk_pkg_name=e3xx_e310_sdk_default-$_artifact_name.zip
		_device=e31x-sg3
	;;
	"x4xx")
		_sdimg_file_name=usrp_x4xx_fs.sdimg
		_mender_file_name=usrp_x4xx_fs.mender
		_recovery_file_name=usrp_x4xx_recovery.zip
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

_sdimg=`find $_deploy_dir/images -name "$_image-ni-$_device*-mender.sdimg" -type l`
if [ ! -r $_sdimg ]; then
	echo "ERROR: Could not find SD card image!" exit 1
fi
echo "Found SD card image: $_sdimg"
echo "Copying SD card image to tmp dir..."
mkdir -p $TMP_DIR
cp -v $_sdimg $TMP_DIR/$_sdimg_file_name
bzip2 $TMP_DIR/$_sdimg_file_name
if [ -r $_sdimg.bmap ]; then
	cp -v $_sdimg.bmap $TMP_DIR/$_sdimg_file_name.bmap
fi
if [ ! -z $_recovery_file_name ]; then
	echo "Finding recovery package..."
	_recovery=`find $_deploy_dir/images -name u-boot-jtag-files.zip`
	if [ ! -r $_recovery ]; then
		echo "ERROR: Could not find recovery package!"
		exit 1
	fi
	cp -v $_recovery $TMP_DIR/$_recovery_file_name
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
if [ ! -z $_sdk_pkg_name ]; then
	echo "Finding SDK..."
	_sdk=`find $_deploy_dir/sdk -name "oecore*.sh" -type f`
	if [ ! -r $_sdk ]; then
		echo "WARNING: Could not find SDK!"
		exit 0
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
