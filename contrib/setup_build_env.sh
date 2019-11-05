#!/bin/bash
#
# Copyright 2018 Ettus Research, a National Instruments Company
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Utility to initialize a build directory to build filesystems for embedded
# USRPs.

if [[ $# -eq 0 ]]; then
	echo "Usage: $0 device_type [artifact_name [src_dir [build_dir]]]"
	echo ""
	echo "Arguments:"
	echo "- device_type: The name of the device that is being targeted (e.g. 'n3xx')"
	echo "- artifact_name: The artifact name that gets stored on the filesystem (e.g. 'v3.13.0.2')"
	echo "- src_dir: The directory in which the layers are stored (defaults to the \$HOME directory)"
	echo "- build_dir: The directory in which builds happen (defaults to \$HOME/build)"
	exit 0
fi

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

_requested_device=$1
_header="## setup_build_env.sh: Automated changes"
case $_requested_device in
	"n3xx")
		read -d '' _auto_conf_edits <<- _EOF_
		$_header
		DISTRO ?= "Alchemy"
		MACHINE ?= "ni-sulfur-rev11-mender"
		INHERIT += "mender-full"
		MENDER_ARTIFACT_NAME = "${_artifact_name}_n3xx"
		IMAGE_ROOTFS_EXTRA_SPACE = "0"
		PACKAGECONFIG_pn-gnuradio = "uhd zeromq"
		_EOF_
		_bb_layers="\
		  /oe-core/meta \
		  /meta-oe/meta-oe \
		  /meta-oe/meta-python \
		  /meta-oe/meta-filesystems \
		  /meta-oe/meta-networking \
		  /meta-security/meta-tpm \
		  /meta-mender/meta-mender-core \
		  /meta-ettus/meta-ettus-core \
		  /meta-ettus/meta-alchemy \
		  /meta-ettus/meta-sulfur \
		  /meta-ettus/meta-mender-sulfur \
		  /meta-sdr \
		  /meta-qt4"
	;;
	"e320")
		read -d '' _auto_conf_edits <<- _EOF_
		$_header
		DISTRO ?= "Alchemy"
		MACHINE ?= "ni-neon-rev2-mender"
		INHERIT += "mender-full"
		MENDER_ARTIFACT_NAME = "${_artifact_name}_e320"
		IMAGE_ROOTFS_EXTRA_SPACE = "0"
		PACKAGECONFIG_pn-gnuradio = "uhd zeromq"
		_EOF_
		_bb_layers="\
		  /oe-core/meta \
		  /meta-oe/meta-oe \
		  /meta-oe/meta-python \
		  /meta-oe/meta-filesystems \
		  /meta-oe/meta-networking \
		  /meta-mender/meta-mender-core \
		  /meta-security/meta-tpm \
		  /meta-ettus/meta-ettus-core \
		  /meta-ettus/meta-alchemy \
		  /meta-ettus/meta-neon \
		  /meta-ettus/meta-mender-neon \
		  /meta-sdr \
		  /meta-qt4"
	;;
	"e310_sg1")
		read -d '' _auto_conf_edits <<- _EOF_
		$_header
		DISTRO ?= "Alchemy"
		MACHINE ?= "ni-e31x-sg1-mender"
		INHERIT += "mender-full"
		MENDER_ARTIFACT_NAME = "${_artifact_name}_e310_sg1"
		IMAGE_ROOTFS_EXTRA_SPACE = "0"
		PACKAGECONFIG_pn-gnuradio = "uhd zeromq"
		_EOF_
		_bb_layers="\
		  /oe-core/meta \
		  /meta-oe/meta-oe \
		  /meta-oe/meta-python \
		  /meta-oe/meta-filesystems \
		  /meta-oe/meta-networking \
		  /meta-mender/meta-mender-core \
		  /meta-security/meta-tpm \
		  /meta-ettus/meta-ettus-core \
		  /meta-ettus/meta-alchemy \
		  /meta-ettus/meta-e31x \
		  /meta-ettus/meta-mender-e31x \
		  /meta-sdr \
		  /meta-qt4"
	;;
	"e310_sg3")
		read -d '' _auto_conf_edits <<- _EOF_
		$_header
		DISTRO ?= "Alchemy"
		MACHINE ?= "ni-e31x-sg3-mender"
		INHERIT += "mender-full"
		MENDER_ARTIFACT_NAME = "${_artifact_name}_e310_sg3"
		IMAGE_ROOTFS_EXTRA_SPACE = "0"
		PACKAGECONFIG_pn-gnuradio = "uhd zeromq"
		_EOF_
		_bb_layers="\
		  /oe-core/meta \
		  /meta-oe/meta-oe \
		  /meta-oe/meta-python \
		  /meta-oe/meta-filesystems \
		  /meta-oe/meta-networking \
		  /meta-mender/meta-mender-core \
		  /meta-security/meta-tpm \
		  /meta-ettus/meta-ettus-core \
		  /meta-ettus/meta-alchemy \
		  /meta-ettus/meta-e31x \
		  /meta-ettus/meta-mender-e31x \
		  /meta-sdr \
		  /meta-qt4"
	;;
	*)
		echo "Unknown device type: $_requested_device. Aborting."
		exit 1
	;;
esac

echo "Using top-level source dir: $_requested_device"
echo "Using device type: $_requested_device"
echo "Using build directory: $_build_dir"
echo "Using artifact name: ${_artifact_name}_${_requested_device}"

source $_src_dir/oe-core/oe-init-build-env $_build_dir $_src_dir/bitbake

echo "Adding layers..."
for bb_layer in $_bb_layers
do
	echo "Adding layer: $_src_dir/$bb_layer"
	bitbake-layers add-layer $_src_dir/$bb_layer
done

_auto_conf=$_build_dir/conf/auto.conf

echo "Creating $_auto_conf..."
echo "$_auto_conf_edits" > $_auto_conf

echo "You can now run 'bitbake <image>'"
echo "where <image> is e.g. developer-image or gnuradio-image."
