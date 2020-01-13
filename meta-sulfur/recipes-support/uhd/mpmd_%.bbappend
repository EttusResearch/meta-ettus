FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " file://usrp_shutdown.py \
                           "

FILES_${PN}-tools_append_ni-sulfur = " \
                                /lib/systemd/system-shutdown/usrp_shutdown.py \
                               "

do_install_append_ni-sulfur() {
    install -D -m 0577 ${WORKDIR}/usrp_shutdown.py ${D}/lib/systemd/system-shutdown/usrp_shutdown.py
}
