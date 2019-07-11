require includes/maintainer-ettus.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
DESCRIPTION = "Hostname utility for the Ettus Research E31x SDR"
PV="0.10"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

PR="r0"

COMPATIBLE_MACHINE = "ni-e31x"

inherit systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN}= "hostname-serial.service"

SRC_URI = " \
           file://COPYING \
           file://usrp_hostname \
           file://eeprom-id \
           file://hostname-serial.service"

FILES_${PN} = "${base_libdir}/systemd/system/ \
               ${base_sbindir} \
               ${bindir}/eeprom-id \
              "
RDEPENDS_${PN} = "bash python3"

do_install_append() {
	install -d ${D}${base_libdir}/systemd/system
	install -d ${D}${base_sbindir}
	install -d ${D}${bindir}
	install -m 0644 ${WORKDIR}/hostname-serial.service ${D}${base_libdir}/systemd/system/
	install -m 0755 ${WORKDIR}/eeprom-id ${D}${bindir}/eeprom-id
	install -m 0755 ${WORKDIR}/usrp_hostname ${D}${base_sbindir}/usrp_hostname
}
