SUMMARY = "A console-only image with a development/debug \
environment and also GNURadio installed."

require default-packages.inc

IMAGE_FEATURES += "splash ssh-server-openssh tools-sdk \
                   debug-tweaks \
                   dev-pkgs \
                  "

EXTRA_IMAGE_FEATURES += "package-management"

LICENSE = "MIT"

IMAGE_INSTALL += " \
    ${CORE_IMAGE_BASE_INSTALL} \
    packagegroup-sdr-python-extended \
    packagegroup-sdr-gnuradio-base \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'xauth', '', d)} \
    gr-ettus \
    "

inherit core-image image-buildinfo
TOOLCHAIN_HOST_TASK += "nativesdk-python3-setuptools \
                        nativesdk-python3-mako \
                       "
