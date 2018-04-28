FILESEXTRAPATHS_prepend_ni-e31x := "${THISDIR}/files:"

SPL_BINARY_ni-e31x = "boot.bin"
UBOOT_SUFFIX_ni-e31x = "img"
UBOOT_BINARY_ni-e31x = "u-boot.${UBOOT_SUFFIX}"

SRC_URI_prepend_ni-e31x = " \
    file://0001-ni-zynq-Add-support-for-NI-E31x-SG1-SG3-boards.patch \
    "
