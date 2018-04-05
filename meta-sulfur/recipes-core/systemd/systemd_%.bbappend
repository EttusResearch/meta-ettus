FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " file://system.conf \
                             file://eth.network \
                             file://70-sfp-net.rules \
                           "

FILES_${PN}_append += " \
    ${sysconfdir}/udev/rules.d/70-sfp-net.rules \
"

do_install_append_ni-sulfur() {
    install -m 0755 ${WORKDIR}/70-sfp-net.rules ${D}/${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd
}
