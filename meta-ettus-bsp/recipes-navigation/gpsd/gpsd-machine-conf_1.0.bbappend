PACKAGE_ARCH = "${MACHINE_ARCH}"

FILESEXTRAPATHS:prepend:ni-e31x := "${THISDIR}/files/ni-e31x:"
FILESEXTRAPATHS:prepend:ni-neon := "${THISDIR}/files/ni-neon:"
FILESEXTRAPATHS:prepend:ni-sulfur := "${THISDIR}/files/ni-sulfur:"
FILESEXTRAPATHS:prepend:ni-titanium := "${THISDIR}/files/ni-titanium:"

SRC_URI = " \
    file://gpsd-machine \
    file://device-hook \
"
SRC_URI:append:ni-e31x = " file://ubx.c"

inherit update-alternatives

ALTERNATIVE:${PN} = "gpsd-defaults"
ALTERNATIVE_LINK_NAME[gpsd-defaults] = "${sysconfdir}/default/gpsd"
ALTERNATIVE_TARGET[gpsd-defaults] = "${sysconfdir}/default/gpsd.machine"
ALTERNATIVE_PRIORITY[gpsd-defaults] = "100"

COMPATIBLE_MACHINE:ni-e31x = ".*"
COMPATIBLE_MACHINE:ni-neon = ".*"
COMPATIBLE_MACHINE:ni-sulfur = ".*"
COMPATIBLE_MACHINE:ni-titanium = ".*"

RREPLACES:${PN} += "gpsd-conf"

TARGET_CC_ARCH += "${LDFLAGS}"

do_compile:append:ni-e31x() {
    ${CC} ${WORKDIR}/ubx.c -o ${B}/ubx
}

do_install() {
    install -d ${D}/${sysconfdir}/default
    install -m 0644 ${WORKDIR}/gpsd-machine ${D}/${sysconfdir}/default/gpsd.machine
    install -d ${D}${sysconfdir}/gpsd/
    install -m 0755 ${WORKDIR}/device-hook ${D}/${sysconfdir}/gpsd/device-hook
}

do_install:append:ni-e31x() {
    install -d ${D}${base_sbindir}
    install -m 0755 ${B}/ubx ${D}/${base_sbindir}/ubx
}