FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI_ni-titanium = " \
    file://gpsd-machine.titanium \
    file://device-hook.titanium \
"

inherit update-alternatives

ALTERNATIVE_${PN}_ni-titanium = "gpsd-defaults"
ALTERNATIVE_LINK_NAME[gpsd-defaults] = "${sysconfdir}/default/gpsd"
ALTERNATIVE_TARGET[gpsd-defaults] = "${sysconfdir}/default/gpsd.machine"
ALTERNATIVE_PRIORITY[gpsd-defaults] = "100"
COMPATIBLE_MACHINE = "ni-titanium"

RREPLACES_${PN} += "gpsd-conf"

do_install_ni-titanium() {
    install -d ${D}/${sysconfdir}/default
    install -m 0644 ${WORKDIR}/gpsd-machine.titanium ${D}/${sysconfdir}/default/gpsd.machine
    install -d ${D}${sysconfdir}/gpsd/
    install -m 0755 ${WORKDIR}/device-hook.titanium ${D}/${sysconfdir}/gpsd/device-hook
}
