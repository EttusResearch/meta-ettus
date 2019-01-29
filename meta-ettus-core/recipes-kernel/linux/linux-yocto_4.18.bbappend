FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-4.18:"

SRC_URI_append = " \
                   file://core.scc \
                   file://core.cfg \
                   file://usrp.scc \
                   file://usrp.cfg \
                 "
