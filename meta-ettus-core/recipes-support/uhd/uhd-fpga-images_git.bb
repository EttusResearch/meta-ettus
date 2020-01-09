require recipes-support/uhd/version.inc
require includes/maintainer-ettus.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGE_ARCH = "${MACHINE_ARCH}"

ALLOW_EMPTY_${PN} = "1"

SRC_URI  += " \
    file://LICENSE.md \
"

UHD_IMAGES_INSTALL_PATH ?= "/usr/share/uhd/images"

LICENSE = "LGPLv3+"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE.md;md5=2d2b59b2fc606f13eb2631fb80325865"
