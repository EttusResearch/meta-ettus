
do_install_append_ni-neon-mender() {
    if ${@bb.utils.contains('PACKAGECONFIG','networkd','true','false',d)}; then
        # copy systemd-network.service to sysconfdir, so that we can modify it
        install -d ${D}${sysconfdir}/systemd/system
        install -m 0644 ${D}${systemd_system_unitdir}/systemd-networkd.service \
          ${D}${sysconfdir}/systemd/system/systemd-networkd.service
        # start systemd-networkd.service after "data" was mounted, otherwise symlinks
        # cannot be followed and the desired links will not be up
        sed -i "s|^\(Wants=.*\)$|\1 data.mount|" ${D}${sysconfdir}/systemd/system/systemd-networkd.service
        sed -i "s|^\(After=.*\)$|\1 data.mount|" ${D}${sysconfdir}/systemd/system/systemd-networkd.service
    fi
}
