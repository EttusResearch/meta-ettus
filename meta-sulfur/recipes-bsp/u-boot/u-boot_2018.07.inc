FILESEXTRAPATHS_prepend_ni-sulfur := "${THISDIR}/files:"

SPL_BINARY_ni-sulfur = "boot.bin"
UBOOT_SUFFIX_ni-sulfur = "img"
UBOOT_BINARY_ni-sulfur = "u-boot.${UBOOT_SUFFIX}"

SRC_URI_prepend_ni-sulfur = " \
    file://0001-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
    "
