FILESEXTRAPATHS_prepend_ni-neon := "${THISDIR}/files:"

SRC_URI_append_ni-neon = " \
                           file://70-sfp-net.rules \
                           file://eth0.network \
                           file://sfp0.network \
                           "

FILES_${PN}_append_ni-neon = " \
    ${sysconfdir}/udev/rules.d/70-sfp-net.rules \
"

do_install_append_ni-neon() {
    install -m 0755 ${WORKDIR}/70-sfp-net.rules ${D}/${sysconfdir}/udev/rules.d/
}
