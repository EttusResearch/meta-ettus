FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "\
            file://salt-minion.service \
           "

do_install_append() {
	install -d ${D}${base_libdir}/systemd/system
	install -m 0644 ${WORKDIR}/salt-minion.service ${D}${base_libdir}/systemd/system/
}

FILES_${PN}-minion_append = " ${base_libdir} \
                              ${base_libdir}/systemd \
                              ${base_libdir}/systemd/system \
                              ${base_libdir}/systemd/system/salt-minon.service \
                             "
inherit systemd

SYSTEMD_SERVICE_${PN}-minion = "salt-minion.service"
