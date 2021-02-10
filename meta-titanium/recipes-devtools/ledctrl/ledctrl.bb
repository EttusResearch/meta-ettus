require includes/maintainer-ettus.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
DESCRIPTION = "LED control for Ettus Research Titanium SDR"
PV="0.1"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "ni-titanium"

inherit systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN}= "\
        ledctrl-led0.service \
        ledctrl-led1.service \
        ledctrl-led2.service \
        "

SRC_URI = " \
           file://COPYING \
           file://ledctrl \
           file://ledctrl-led0.service \
           file://ledctrl-led1.service \
           file://ledctrl-led2.service \
           "

FILES_${PN} = "${base_libdir}/systemd/system/ \
               ${base_sbindir} \
              "
RDEPENDS_${PN} = "bash"

do_install_append() {
	install -d ${D}${base_libdir}/systemd/system
	install -d ${D}${base_sbindir}
	install -m 0644 ${WORKDIR}/ledctrl-led*.service ${D}${base_libdir}/systemd/system/
	install -m 0755 ${WORKDIR}/ledctrl ${D}${base_sbindir}/ledctrl
}
