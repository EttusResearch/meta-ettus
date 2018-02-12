FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
DESCRIPTION = "Migration script to move old network configuration Ettus Research N3xx SDR"
PV="0.10"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

MACHINE_COMPATIBLE="ni-sulfur-rev5"

PR="r1"

inherit systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN}= "sfp-migrate.service"

SRC_URI = " \
           file://COPYING \
           file://usrp_sfp_migrate \
           file://sfp-migrate.service"

FILES_${PN} = "${base_libdir}/systemd/system/ \
               ${base_sbindir} \
              "
RDEPENDS_${PN} = "bash"

do_install_append() {
	install -d ${D}${base_libdir}/systemd/system
	install -d ${D}${base_sbindir}
	install -m 0644 ${WORKDIR}/sfp-migrate.service ${D}${base_libdir}/systemd/system/
	install -m 0755 ${WORKDIR}/usrp_sfp_migrate ${D}${base_sbindir}/usrp_sfp_migrate
}
