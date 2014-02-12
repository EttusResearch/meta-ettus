DESCRIPTION = "A console-only image with more full-featured Linux system \
functionality installed."

IMAGE_FEATURES += "splash ssh-server-openssh tools-sdk \
                   tools-debug tools-profile debug-tweaks \
                   dev-pkgs dbg-pkgs \
                  "

EXTRA_IMAGE_FEATURES += "package-management"

LICENSE = "MIT"

TOOLCHAIN_HOST_TASK_append = " nativesdk-python-cheetah nativesdk-python-netserver nativesdk-python-pprint nativesdk-python-pickle nativesdk-orc"

CORE_IMAGE_EXTRA_INSTALL = "\
    alsa-utils \
    i2c-tools \
    screen \
    vim \
    vim-vimrc \
    git \
    boost \
    cmake \
    python \
    python-cheetah \
    python-modules \
    python-argparse \
    htop \
    sshfs-fuse \
    glib-2.0 \
    orc \
    libudev \
    ntpdate \
    "

inherit core-image
