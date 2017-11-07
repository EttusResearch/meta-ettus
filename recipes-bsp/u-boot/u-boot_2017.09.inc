FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-${PV}:"

SRC_URI_append_ni-sulfur = " \
    file://sulfur/0001-i2c-muxes-pca954x-Add-support-for-GPIO-reset-line.patch \
    file://sulfur/0001-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
    file://sulfur/0002-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
    file://sulfur/0003-ni-sulfur-rev3-Added-swsync-feature.patch \
    file://sulfur/0004-ni-sulfur-rev3-Add-autoboot-support.patch \
    file://sulfur/0005-ni-sulfur-rev3-Fix-defconfig-for-2017.09.patch \
    file://sulfur/0010-i2c-mux-pca954x-Add-addtitional-compatible-string-fo.patch \
    file://sulfur/0012-board-ni-zynq-Add-parsing-code-for-sulfur.patch \
    file://sulfur/0013-misc-cros_ec-Add-trivial-support-for-software-sync.patch \
    "

SPL_BINARY = "boot.bin"
UBOOT_SUFFIX = "img"
UBOOT_BINARY = "u-boot.${UBOOT_SUFFIX}"
