FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-4.15:"

SRC_URI_append = " \
                   file://core.scc \
                   file://core.cfg \
                 "
