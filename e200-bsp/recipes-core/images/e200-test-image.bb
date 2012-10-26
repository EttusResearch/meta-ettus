DESCRIPTION = "A console-only image with more full-featured Linux system \
functionality installed."

IMAGE_FEATURES += "splash ssh-server-openssh tools-sdk \
                   tools-debug debug-tweaks"

IMAGE_INSTALL = "\
    packagegroup-core-boot \
    packagegroup-core-basic \
    kernel-modules \
    i2c-tools \
    vim \
    boost-dev \
    cmake \
    python \
    python-cheetah \
    "

inherit core-image
