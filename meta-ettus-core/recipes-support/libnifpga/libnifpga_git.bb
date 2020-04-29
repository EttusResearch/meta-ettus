SUMMARY = "libnifpga"
HOMEPAGE = "https://www.ettus.com"
SECTION = "libs"
LICENSE = "LGPLv2.1+"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/LGPL-2.1;md5=1a6d268fd218675ffea8be556788b780"
require includes/maintainer-ettus.inc

SRC_URI = "git://github.com/ni/libnifpga-usrp.git;branch=main"
SRCREV = "3180a075e585a47b67479d8b91e0ea9f93eab038"
PV = "0.1+git${SRCPV}"

DEPENDS = "virtual/kernel"

S = "${WORKDIR}/git"

inherit cmake
