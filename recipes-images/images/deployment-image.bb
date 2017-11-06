SUMMARY = "A console-only image with a development/debug \
environment suitable for building GNURadio installed."

require version-image.inc

IMAGE_FEATURES += "ssh-server-openssh tools-sdk \
                   debug-tweaks \
                  "

EXTRA_IMAGE_FEATURES += "package-management"

LICENSE = "MIT"

require recipes-images/images/native-sdk.inc

CORE_IMAGE_EXTRA_INSTALL = "\
    screen \
    vim \
    vim-vimrc \
    git \
    swig \
    boost \
    cmake \
    gsl \
    python \
    python-mako \
    python-modules \
    python-argparse \
    python-distutils \
    python-numpy \
    glib-2.0 \
    orc \
    libudev \
    openssh-sftp \
    openssh-sftp-server \
    fftwf-wisdom \
    uhd \
    uhd-examples \
    eeprom-tools \
    eeprom-tools-systemd \
    usrp-hwd \
    openocd \
    salt-minion \
    trousers \
    tpm-tools \
    "

inherit core-image image-buildinfo

MENDER_DATA_PART_DIR_append = "${DEPLOY_DIR_IMAGE}/persist"
