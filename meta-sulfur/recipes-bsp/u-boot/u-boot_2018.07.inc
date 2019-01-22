FILESEXTRAPATHS_prepend_ni-sulfur := "${THISDIR}/u-boot-2018.01:"

SPL_BINARY_ni-sulfur = "boot.bin"
UBOOT_SUFFIX_ni-sulfur = "img"
UBOOT_BINARY_ni-sulfur = "u-boot.${UBOOT_SUFFIX}"

SRC_URI_prepend_ni-sulfur = " \
    file://0001-misc-cros_ec-Add-trivial-support-for-software-sync.patch \
    file://0002-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
    file://0003-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
    file://0004-ni-zynq-Add-support-for-Project-Phosphorus.patch \
    file://0005-ni-zynq-n3xx-eeprom-Add-support-for-version-2-EEPROM.patch \
    file://0006-ni-sulfur-rev3-Added-swsync-feature.patch \
    "
