SUMMARY = "libnifpga"
HOMEPAGE = "https://www.ettus.com"
SECTION = "libs"
LICENSE = "LGPLv2.1+"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/LGPL-2.1;md5=1a6d268fd218675ffea8be556788b780"
require includes/maintainer-ettus.inc

SRC_URI = "git://ni@vs-ssh.visualstudio.com/v3/ni/Users/mauchter-libnifpga;branch=master;protocol=ssh"
SRCREV = "6d26e7b9600f1f156fbb288323b1de0bcc49450e"
PV = "0.1+git${SRCPV}"

DEPENDS = "virtual/kernel"

S = "${WORKDIR}/git"

inherit cmake
