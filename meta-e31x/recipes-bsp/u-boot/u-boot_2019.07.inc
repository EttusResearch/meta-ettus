FILESEXTRAPATHS_prepend_ni-e31x := "${THISDIR}/files:"

SRC_URI_prepend_ni-e31x = " \
    file://0001-ni-zynq-Add-support-for-NI-E31x-SG1-SG3-boards.patch \
    file://0002-configs-ni_e31x_sg-1-3-Added-network-commands-dhcp-t.patch \
    file://0003-configs-ni_e31x_sg-1-3-add-CONFIG_USE_BOOTCOMMAND.patch \
    "
