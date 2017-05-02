DESCRIPTION = "Utilities for the Ettus Research Sulfur SDR EEPROM"
PV="0.10+gitr${SRCPV}"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"
SRCREV = "bfde9de0c58280d832f448dfe502fb22246255d2"
SRC_URI = "git://orbitty.amer.corp.natinst.com/brimstone-utils;branch=n3xx-eeprom-utils"

S = "${WORKDIR}/git"

inherit autotools

DEPENDS += " gnulib gettext"
