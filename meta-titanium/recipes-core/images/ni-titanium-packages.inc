DEPENDS += "python3-six-native"

IMAGE_INSTALL += " \
    ${CORE_IMAGE_BASE_INSTALL} \
    bmap-tools \
    chromium-ec-utils \
    gdbserver \
    libmetal \
    mpmd-tests \
    mtd-utils \
    python3 \
    python3-debugger \
    python3-nifpga \
    python3-mako \
    "

TOOLCHAIN_HOST_TASK += " \
    nativesdk-python3-mako \
    nativesdk-python3-numpy \
    nativesdk-python3-setuptools \
    "
