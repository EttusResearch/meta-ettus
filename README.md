meta-ettus
==========

This repository contains various layers for different NI (Ettus Research) Products

Supported devices
=================

  - NI USRP X410 (meta-titanium)
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

**meta-titanium**:

- Contains X410 BSP. Defines machines such as ni-titanium-rev5.

**meta-mender-titanium**:

- Contains changes for X410 mender.io integration
- Defines new machines such as ni-titanium-rev5-mender to build with mender.io integration.

**meta-e31x:**

- Contains E310/E312/E313 BSP

**meta-mender-e31x:**

- Contains changes for E310/E312/E313 mender.io integration.

Building an Image using the kas image builder script
====================================================

This repository provides a script that can be used to build filesystem images
for the various supported USRP devices. The script relies on [kas](https://github.com/siemens/kas) which
orchestrates environment and dependency setup for building the images.

We recommend building USRP images with the offical kas docker images. You can
get those [here](https://ghcr.io/siemens/kas/kas).

From the top level of this repository, run ``./contrib/kas_build_imgs_package.sh``
without arguments to get the help message of this script.

Run the script, e.g., for the N310:

    ./meta-ettus/contrib/kas_build_imgs_package.sh n3xx v4.1.0.0

This will setup the environment, build, and zip up the filesystem image,
the SDK, and the Mender artifact.

Building an Image using the Alchemy distro and kas
==================================================

We recommend building USRP images with the offical kas docker images. You can
get those [here](https://ghcr.io/siemens/kas/kas) or use
[kas-container](https://github.com/siemens/kas/blob/master/kas-container), which helps automate the container.

To build an image with kas, call

    kas build ./kas/[devicename].yml

The yml files define properties and dependencies for the images. You can override
these by setting environment variables. For example, you can change the mender
image name that appears when calling ``mender show-artifact`` by
calling ``export MENDER_ARTIFACT_NAME=Custom_Artifact_Name``.

Specifying the UHD version to use
=================================

The repository contains different recipes for building different versions of
UHD, see the recipe files in meta-ettus-core/recipes-support/uhd.

You can specify the UHD version to use by setting the variable
PREFERRED_UHD_VERSION in the ``./kas/base.yml`` env section. Example for forcing UHD 4.1:

    PREFERRED_UHD_VERSION: "4.1%"

Please note the '%' symbol at the end which is used to match any 4.1 version
(e.g. 4.1.0.0+gitGITHASH).

The Alchemy.conf file (meta-alchemy/conf/distro/Alchemy.conf) will automatically
set the appropriate versions for the uhd, uhd-fpga-images and mpmd recipes:

    PREFERRED_VERSION_pn-uhd ?= "${PREFERRED_UHD_VERSION}"
    PREFERRED_VERSION_pn-uhd-fpga-images ?= "${PREFERRED_UHD_VERSION}"
    PREFERRED_VERSION_pn-mpmd ?= "${PREFERRED_UHD_VERSION}"

The default value for PREFERRED_UHD_VERSION is also set in the Alchemy.conf
file. It is set to the latest released version of UHD per default.
