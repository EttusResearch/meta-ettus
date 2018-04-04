FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-2017.09:"

SPL_BINARY = "boot.bin"
UBOOT_SUFFIX = "img"
UBOOT_BINARY = "u-boot.${UBOOT_SUFFIX}"

SRC_URI_prepend_ni-sulfur = " \
    file://0001-i2c-muxes-pca954x-Add-support-for-GPIO-reset-line.patch \
    file://0002-misc-cros_ec-Add-trivial-support-for-software-sync.patch \
    file://0003-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
    file://0004-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
    file://0005-ni-sulfur-rev3-Added-swsync-feature.patch \
    file://0001-ni-zynq-Add-support-for-Project-Phosphorus.patch \
    "
