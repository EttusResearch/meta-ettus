
FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-5.2:"

SRC_URI_append = " \
                   file://defconfig \
                   file://core.scc \
                   file://core.cfg \
                   file://debug.cfg \
                   file://usrp.scc \
                   file://usrp.cfg \
                 "
