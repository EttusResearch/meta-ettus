DESCRIPTION = "Host packages for GNU Radio SDK"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"
LICENSE = "MIT"

ALLOW_EMPTY = "1"

inherit nativesdk

PACKAGES = "${PN}"

RDEPENDS_${PN} = " \
    pkgconfig-sdk \
    opkg-sdk \
    libtool-sdk \
"
