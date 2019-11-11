FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI_ni-e31x = " \
    file://gpsd-machine.e31x \
    file://device-hook.e31x \
    file://ubx.c \
"

inherit update-alternatives

ALTERNATIVE_${PN}_ni-e31x = "gpsd-defaults"
ALTERNATIVE_LINK_NAME[gpsd-defaults] = "${sysconfdir}/default/gpsd"
ALTERNATIVE_TARGET[gpsd-defaults] = "${sysconfdir}/default/gpsd.machine"
ALTERNATIVE_PRIORITY[gpsd-defaults] = "100"
COMPATIBLE_MACHINE_ni-e31x = "ni-e31x-sg1|ni-e31x-sg3"

RREPLACES_${PN} += "gpsd-conf"

S = "${WORKDIR}"

TARGET_CC_ARCH += "${LDFLAGS}"

do_compile_ni-e31x() {
    ${CC} ubx.c -o ubx
}

do_install_ni-e31x() {
    install -d ${D}/${sysconfdir}/default
    install -m 0644 ${WORKDIR}/gpsd-machine.e31x ${D}/${sysconfdir}/default/gpsd.machine
    install -d ${D}${sysconfdir}/gpsd/
    install -m 0755 ${WORKDIR}/device-hook.e31x ${D}/${sysconfdir}/gpsd/device-hook
    install -d ${D}${base_sbindir}
    install -m 0755 ${WORKDIR}/ubx ${D}/${base_sbindir}/ubx
}
