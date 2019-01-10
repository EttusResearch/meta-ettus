FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

ALLOW_EMPTY_${PN} = "1"

PR = "r0"
PV = "3.13.1.0"

SRC_URI  = " \
    file://LICENSE.md \
"

LICENSE = "LGPLv3+"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE.md;md5=2d2b59b2fc606f13eb2631fb80325865"
