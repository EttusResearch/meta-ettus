meta-ettus
==========

This repository contains various layers for different NI (Ettus Research) Products

Supported devices
=================

  - NI USRP N310/N300 series (meta-sulfur)
  - NI USRP E320 series (meta-neon)
  - NI USRP E310/E312/E313 (meta-e31x)


Repository organization
=======================

The repository is split into several sublayers to allow for greater modularity.

**meta-alchemy:**

- Contains common distro configuration

**meta-ettus-core:**

- Contains common core recipes, such as the developer-image

**meta-neon:**

- Contains E320 BSP. Defines machines such as ni-neon-rev1, ni-neon-rev2, etc.

**meta-mender-neon:**

- Contains changes for E320 mender.io integration.
- Defines new machines ni-neon-rev2-mender to build with mender.io integration.

**meta-sulfur:**

- Contains N310/N300 BSP. Defines machines such as ni-sulfur-rev3, ni-sulfur-rev4, etc.

**meta-mender-sulfur:**

- Contains changes for N310/N300 mender.io integration.
- Defines new machines ni-sulfur-rev{2,3,4,5,6}-mender to build with mender.io integration.

**meta-e31x:**

- Contains E310/E312/E313 BSP

**meta-mender-e31x:**

- Contains changes for E310/E312/E313 mender.io integration.

Building an Image using the image builder script
================================================

This repository provides a script that can be used to build filesystem images
for the various supported USRP devices.

From the top level of this repository, run ./contrib/build_imgs_package.sh
without arguments to get the help message of this script.

To run the script, other layers than meta-ettus are required. We provide
manifest files on our oe-manifests repository:
https://github.com/EttusResearch/oe-manifests

To get a consistent set of meta-ettus and other layers, find a suitable version
of the manifest file in the oe-manifests repository, and use repo to check out
the correct versions:

    repo init -u git://github.com/EttusResearch/oe-manifests.git -b $branch

where $branch is the branch or revision of oe-manifests you wish to build. For
example, to reproduce the repositories used for the 3.14.1.1 release, run the
following command:

    repo init -u git://github.com/EttusResearch/oe-manifests.git -b v3.14.1.1

Then, run the script, e.g., for the N310:

    ./meta-ettus/contrib/build_imgs_package.sh n3xx v3.14.1.1 .

This will build and zip up the filesystem image, the SDK, and the Mender
artifact.

Building an Image using the Alchemy distro
===========================================

In your local.conf set a MACHINE from above

MACHINE ??= "ni-sulfur-rev6"
DISTRO ?= "Alchemy"

Additionally when building with mender.io support:

MACHINE ??= "ni-sulfur-rev6-mender"
MENDER_ARTIFACT_NAME ?= "v3.14.1.1_custom"

Where MENDER_ARTIFACT_NAME is an arbitrary string which identifies the Mender
image. It is saved in the file /etc/mender/artifact_info and also displayed
when running:

    mender -show-artifact

In your bblayers.conf make sure you have the required layers
(see sublayer README for individual layer dependencies)

An example for N310/N300 (sulfur) with mender.io support:

    BBLAYERS ?= " \
      /home/oe-builder/oe-core/meta \
      /home/oe-builder/meta-oe/meta-oe \
      /home/oe-builder/meta-oe/meta-python \
      /home/oe-builder/meta-ettus/meta-ettus-core \
      /home/oe-builder/meta-ettus/meta-alchemy \
      /home/oe-builder/meta-security/meta-tpm \
      /home/oe-builder/meta-oe/meta-filesystems \
      /home/oe-builder/meta-oe/meta-networking \
      /home/oe-builder/meta-ettus/meta-sulfur \
      /home/oe-builder/meta-ettus/meta-mender-sulfur \
      /home/oe-builder/meta-mender/meta-mender-core \
      "

Specifying the UHD version to use
=================================

The repository contains different recipes for building different versions of
UHD, see the recipe files in meta-ettus-core/recipes-support/uhd.

You can specify the UHD version to use by setting the variable
PREFERRED_UHD_VERSION in your local.conf file. Example for forcing UHD 4.0:

    PREFERRED_UHD_VERSION = "4.0%"

Please note the '%' symbol at the end which is used to match any 4.0 version
(e.g. 4.0.0.0+gitGITHASH).

The Alchemy.conf file (meta-alchemy/conf/distro/Alchemy.conf) will automatically
set the appropriate versions for the uhd, uhd-fpga-images and mpmd recipes:

    PREFERRED_VERSION_pn-uhd ?= "${PREFERRED_UHD_VERSION}"
    PREFERRED_VERSION_pn-uhd-fpga-images ?= "${PREFERRED_UHD_VERSION}"
    PREFERRED_VERSION_pn-mpmd ?= "${PREFERRED_UHD_VERSION}"

The default value for PREFERRED_UHD_VERSION is also set in the Alchemy.conf
file. It is set to the latest released version of UHD per default.
