This README file contains information on the contents of the meta-titanium layer.

Please see the corresponding sections below for details.

Dependencies
============

  URI: https://github.com/EttusResearch/meta-ettus.git
  layers: meta-ettus-core

Patches
=======

Please submit any patches against the meta-titanium layer via github pull requests.

Maintainer: Joerg Hofrichter <joerg.hofrichter@ni.com>

Table of Contents
=================

  I. Setup of the build environment
  II. Prepare the "multiconfig" configuration
  III. Build the PMU firmware
  IV. Build the filesystem image

I. Setup of the build environment
==================================

Run the following commands in the parent directory of meta-ettus:

  $ TEMPLATECONF=./meta-ettus/meta-titanium/conf
  $ source oe-core/oe-init-build-env ./build/ ./bitbake/

Or if you already have an existing build directory, you can add
this layer by running:

  $ bitbake-layers add-layer meta-titanium

II. Prepare the "multiconfig" configuration
===========================================

A "multiconfig" configuration is needed to be able to build the PMU firmware.
u-boot depends on this, so building the filesystem image fails if PMU firmware
was not built before (at least once).

  $ mkdir -p conf/multiconfig
  $ mv conf/local.conf conf/multiconfig/ni-titanium.conf
  $ cp ../meta-ettus/meta-titanium/conf/zynqmp-pmu.conf.local \
      conf/multiconfig/zynqmp-pmu.conf

III. Build the PMU firmware
===========================

  $ ln -sfn multiconfig/zynqmp-pmu.conf conf/local.conf
  $ bitbake pmu-firmware

IV. Build the filesystem image
==============================

  $ ln -sfn multiconfig/ni-titanium.conf conf/local.conf
  $ bitbake <target>

Supported targets are:

- core-image-base (reduced image with only a few packets)
- deployment-image (UHD/MPMD installed)
- developer-image (UHD/MPMD installed + development environment)
