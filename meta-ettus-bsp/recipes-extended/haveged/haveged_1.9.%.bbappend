inherit systemd

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} = "haveged.service"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${S}/contrib/Fedora/haveged.service ${D}${systemd_system_unitdir}/haveged.service
        sed -i 's|@SBIN_DIR@|${sbindir}|' ${D}${systemd_system_unitdir}/haveged.service
    fi
}
