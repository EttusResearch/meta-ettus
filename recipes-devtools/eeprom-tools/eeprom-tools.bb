DESCRIPTION = "Utilities for the Ettus Research Sulfur SDR EEPROM"
PV="0.10+gitr${SRCPV}"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

MACHINE_COMPATIBLE="ni-sulfur-rev3"

PR="r3"

inherit systemd
SYSTEMD_PACKAGES = "${PN}-systemd"
SYSTEMD_SERVICE_${PN}-systemd = "hostname-serial.service"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRCREV = "87852f126f31a36b64734f36b627996267885433"
SRC_URI = "git://orbitty.ni.corp.natinst.com/brimstone-utils;branch=n3xx-eeprom-utils \
           file://hostname-serial.service"

S = "${WORKDIR}/git"

inherit autotools

DEPENDS += " gnulib gettext"

PACKAGES =+ "${PN}-systemd"
FILES_${PN}-systemd = "${base_libdir}/systemd/system/"
RDEPENDS_${PN}-systemd = "${PN}"

do_install_append() {
	install -d ${D}${base_libdir}/systemd/system
	install -m 0644 ${WORKDIR}/hostname-serial.service ${D}${base_libdir}/systemd/system/
}
