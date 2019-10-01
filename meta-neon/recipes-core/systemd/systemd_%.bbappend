PACKAGECONFIG_append = " networkd resolved"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-neon = " \
                                  file://eth0.network \
                                  file://sfp0.network \
                                  file://70-sfp-net.rules \
                                  "


FILES_${PN}_append_ni-neon = " \
    /data/network/* \
    ${sysconfdir}/systemd/network/* \
    ${sysconfdir}/udev/rules.d/70-sfp-net.rules \
"

FILES_${PN}_append_ni-neon = " \
"

do_install_append_ni-neon() {
    if ${@bb.utils.contains('PACKAGECONFIG','networkd','true','false',d)}; then

        install -d ${D}/data/network
        install -m 0755 ${WORKDIR}/eth0.network ${D}/data/network/eth0.network
        install -m 0755 ${WORKDIR}/sfp0.network ${D}/data/network/sfp0.network

        install -d ${D}${sysconfdir}/systemd/network
        ln -sf /data/network/eth0.network ${D}${sysconfdir}/systemd/network/eth0.network
        ln -sf /data/network/sfp0.network ${D}${sysconfdir}/systemd/network/sfp0.network

    fi

    install -m 0755 ${WORKDIR}/70-sfp-net.rules ${D}/${sysconfdir}/udev/rules.d/
}
