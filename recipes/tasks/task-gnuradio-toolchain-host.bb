DESCRIPTION = "Host packages for GNU Radio SDK"
LICENSE = "MIT"
ALLOW_EMPTY = "1"

inherit sdk

PACKAGES = "${PN}"

RDEPENDS_${PN} = " \
    pkgconfig-sdk \
    opkg-sdk \
    libtool-sdk \
"
