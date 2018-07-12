FILESEXTRAPATHS_prepend_ni-neon := "${THISDIR}/files:"

SPL_BINARY_ni-neon = "boot.bin"
UBOOT_SUFFIX_ni-neon = "img"
UBOOT_BINARY_ni-neon = "u-boot.${UBOOT_SUFFIX}"

SRC_URI_prepend_ni-neon = " \
    file://0002-misc-cros_ec-Add-trivial-support-for-software-sync.patch \
"

SRC_URI_prepend_ni-neon-rev1 = " \
    file://0001-ni-zynq-Add-support-for-NI-Project-Neon-Rev1-SDR.patch \
"

SRC_URI_prepend_ni-neon-rev2 = " \
    file://0001-ni-zynq-Add-support-for-NI-Project-Neon-Rev2-SDR.patch \
"
