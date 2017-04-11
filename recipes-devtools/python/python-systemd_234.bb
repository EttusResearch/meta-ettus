SUMMARY = "Python interface for libsystemd"
HOMEPAGE = "https://github.com/systemd/python-systemd"
LICENSE = "LGPLv2+"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=4fbd65380cdd255951079008b364516c"

PYPI_PACKAGE = "systemd-python"
DEPENDS += "systemd"
RDEPENDS_${PN} += "systemd"
inherit pypi setuptools

SRC_URI[md5sum] = "5071ea5bcb976186e92a3f5e75df221d"
SRC_URI[sha256sum] = "fd0e44bf70eadae45aadc292cb0a7eb5b0b6372cd1b391228047d33895db83e7"
