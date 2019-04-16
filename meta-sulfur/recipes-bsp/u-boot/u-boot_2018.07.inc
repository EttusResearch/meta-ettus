FILESEXTRAPATHS_prepend_ni-sulfur := "${THISDIR}/files:"

SRC_URI_prepend_ni-sulfur = " \
    file://0001-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
    file://0002-ni-zynq-Added-network-commands-dhcp-tftpboot.patch \
    "
