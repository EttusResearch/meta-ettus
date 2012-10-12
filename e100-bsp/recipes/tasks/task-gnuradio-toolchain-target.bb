DESCRIPTION = "Target packages for GNURadio SDK"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"
ALLOW_EMPTY = "1"

DEPENDS = "task-sdk-bare"

RDEPENDS_${PN} += " \
    task-sdk-bare \
    glibc \
    virtual-libc-dev \
    libgcc \
    alsa-dev \
    audiofile-dev \
    bluez-libs-dev \
    dbus-dev \
    expat-dev \
    glib-2.0-dev \
    libice-dev \
    jpeg-dev \
    libapm-dev \
    alsa-lib-dev \
    libetpan-dev \
    libgcrypt-dev \
    gnutls-dev \
    libidl-dev \
    libiw-dev \
    libmimedir-dev \
    libpcap-dev \
    libpng-dev \
    libschedule-dev \
    libsm-dev \
    libsoundgen-dev \
    libsoup-dev \
    libsvg-dev \
    libtododb-dev \
    libts-dev \
    libxml2-dev \
    ncurses-dev \
    popt-dev \
    readline-dev \
    zlib-dev \
    ${GNURADIO_PKGS} \
"

GNURADIO_PKGS = " \
    libusb1-dev \
    fftwf-dev \
    alsa-dev \
    alsa-lib-dev \
    jack-dev \
    cppunit-dev \
    python-dev \
    python-numpy-dev \
    boost-dev \
    gsl-dev \
"
