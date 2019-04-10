FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI_ni-sulfur = " \
    file://gpsd-machine.sulfur \
    file://device-hook.sulfur \
"

inherit update-alternatives

ALTERNATIVE_${PN}_ni-sulfur = "gpsd-defaults"
ALTERNATIVE_LINK_NAME[gpsd-defaults] = "${sysconfdir}/default/gpsd"
ALTERNATIVE_TARGET[gpsd-defaults] = "${sysconfdir}/default/gpsd.machine"
ALTERNATIVE_PRIORITY[gpsd-defaults] = "100"
COMPATIBLE_MACHINE = "ni-sulfur-rev6|ni-sulfur-rev5|ni-sulfur-rev4|ni-sulfur-rev3"

RREPLACES_${PN} += "gpsd-conf"

do_install_ni-sulfur() {
    install -d ${D}/${sysconfdir}/default
    install -m 0644 ${WORKDIR}/gpsd-machine.sulfur ${D}/${sysconfdir}/default/gpsd.machine
    install -d ${D}${sysconfdir}/gpsd/
    install -m 0755 ${WORKDIR}/device-hook.sulfur ${D}/${sysconfdir}/gpsd/device-hook
}
