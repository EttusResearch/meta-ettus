SUMMARY = "A console-only image with a development/debug \
environment suitable for building GNURadio installed."

#require version-image.inc

IMAGE_FEATURES += "splash ssh-server-openssh tools-sdk \
                   debug-tweaks \
                   dev-pkgs \
                  "

EXTRA_IMAGE_FEATURES += "package-management"

LICENSE = "MIT"

CORE_IMAGE_EXTRA_INSTALL = "\
    i2c-tools \
    devmem2 \
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
    htop \
    glib-2.0 \
    orc \
    overlay-script \
    libudev \
    iperf3 \
    openssh-sftp \
    openssh-sftp-server \
    fftwf-wisdom \
    uhd \
    uhd-examples \
    python3-pip \
    ethtool \
    sshfs-fuse \
    tzdata \
    trousers \
    tpm-tools \
    "

#eeprom-hostname-systemd
#migrate-netcfg-systemd
#usrp-hwd
#openocd
#salt-minion

inherit core-image image-buildinfo

#MENDER_DATA_PART_DIR_append = "${DEPLOY_DIR_IMAGE}/persist"
