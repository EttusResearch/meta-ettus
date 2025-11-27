MPM_DEVICE:ni-sulfur = "n3xx"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:ni-sulfur = " file://usrp_shutdown.py \
                           "

FILES:${PN}-tools:append:ni-sulfur = " \
                                ${base_libdir}/systemd/system-shutdown/usrp_shutdown.py \
                               "

do_install:append:ni-sulfur() {
    install -D -m 0577 ${WORKDIR}/usrp_shutdown.py ${D}${base_libdir}/systemd/system-shutdown/usrp_shutdown.py
}
