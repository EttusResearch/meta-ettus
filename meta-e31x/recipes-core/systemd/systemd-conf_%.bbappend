FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-e31x = " \
                                  file://eth0.network \
                                  "


FILES_${PN}_append_ni-e31x = " \
    /data/network/* \
    ${sysconfdir}/systemd/network/* \
"

FILES_${PN}_append_ni-e31x = " \
"

do_install_append_ni-e31x() {
    install -d ${D}/data/network
    install -m 0755 ${WORKDIR}/eth0.network ${D}/data/network/eth0.network

    install -d ${D}${sysconfdir}/systemd/network
    ln -sf /data/network/eth0.network ${D}${sysconfdir}/systemd/network/eth0.network
}
