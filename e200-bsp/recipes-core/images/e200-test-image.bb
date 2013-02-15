DESCRIPTION = "A console-only image with more full-featured Linux system \
functionality installed."

IMAGE_FEATURES += "splash ssh-server-openssh tools-sdk \
                   tools-debug debug-tweaks"

EXTRA_IMAGE_FEATURES += "package-management"

LICENSE = "MIT"

CORE_IMAGE_EXTRA_INSTALL = "\
    alsa-utils \
    i2c-tools \
    screen \
    vim \
    vim-vimrc \
    git \
    boost-dev \
    cmake \
    python \
    python-cheetah \
    python-modules \
    python-argparse \
    htop \
    sshfs-fuse \
    glib-2.0-dev \
    orc-dev \
    libudev-dev \
    libudev \
    "

inherit core-image
