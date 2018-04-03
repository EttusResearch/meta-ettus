FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-4.12:"

SRC_URI_append = " \
                   file://core.scc \
                 "
