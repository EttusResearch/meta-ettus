FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI_ni-neon = " \
    file://gpsd-machine \
    file://device-hook \
"

inherit update-alternatives

ALTERNATIVE_${PN}_ni-neon = "gpsd-defaults"
ALTERNATIVE_LINK_NAME[gpsd-defaults] = "${sysconfdir}/default/gpsd"
ALTERNATIVE_TARGET[gpsd-defaults] = "${sysconfdir}/default/gpsd.machine"
ALTERNATIVE_PRIORITY[gpsd-defaults] = "100"
COMPATIBLE_MACHINE = "ni-neon-rev1"

RREPLACES_${PN} += "gpsd-conf"

do_install_ni-neon() {
    install -d ${D}/${sysconfdir}/default
    install -m 0644 ${WORKDIR}/gpsd-machine ${D}/${sysconfdir}/default/gpsd.machine
    install -d ${D}${sysconfdir}/gpsd/
    install -m 0755 ${WORKDIR}/device-hook ${D}/${sysconfdir}/gpsd/device-hook
}
