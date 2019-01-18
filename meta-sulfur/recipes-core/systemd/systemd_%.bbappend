FILESEXTRAPATHS_prepend_ni-sulfur := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " file://eth.network \
                             file://70-sfp-net.rules \
                           "

FILES_${PN}_append_ni-sulfur = " \
    ${sysconfdir}/udev/rules.d/70-sfp-net.rules \
"

do_install_append_ni-sulfur() {
    install -m 0755 ${WORKDIR}/70-sfp-net.rules ${D}/${sysconfdir}/udev/rules.d/
}
