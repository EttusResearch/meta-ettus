FILESEXTRAPATHS_prepend_ni-neon := "${THISDIR}/files:"

SRC_URI_prepend_ni-neon-rev1 = " \
    file://0001-ni-zynq-Add-support-for-NI-Project-Neon-Rev1-SDR.patch \
"

SRC_URI_prepend_ni-neon-rev2 = " \
    file://0001-ni-zynq-Add-support-for-NI-Project-Neon-Rev2-SDR.patch \
    file://0002-ni-zynq-Added-network-commands-dhcp-tftpboot.patch \
    file://0003-ni-zynq-set-bootdelay-to-3-seconds.patch \
    file://0004-ni-zynq-Add-tftp-port-selection.patch \
"
