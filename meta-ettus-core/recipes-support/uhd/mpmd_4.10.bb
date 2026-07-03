require uhd_4.10_src.inc
require mpmd.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/mpmd-4.10:"

LIC_FILES_CHKSUM = "file://../host/LICENSE;md5=8255adf1069294c928e0e18b01a16282"

SRC_URI += " \
    file://0001-mpm-Add-rpc_version-key-in-device-find-routine.patch;patchdir=.. \
    file://0002-mpm-apply-ni-python-styleguide-fix-to-_bist.patch;patchdir=.. \
    file://0003-mpm-sys_utils.i2c_dev-rework-e.g.-don-t-rely-on-i2c-.patch;patchdir=.. \
    file://0004-mpm-n3xx-adopt-nvmem-paths-in-eeprom-tools.patch;patchdir=.. \
    file://0005-mpm-check-filesystem-format-and-adopt-to-Python-3.12.patch;patchdir=.. \
    file://0006-mpm-add-executable-flags-to-x4xx_bist.patch;patchdir=.. \
    file://0007-mpm-apply-ni-python-styleguide-fix-to-_bist.patch;patchdir=.. \
    file://0008-mpm-tools-apply-clang-format.patch;patchdir=.. \
    file://0009-mpm-tools-Use-dts-labels-for-mb-db-eeproms.patch;patchdir=.. \
    file://0010-mpm-refactor-thermal-fan-sensor-handling-with-unifie.patch;patchdir=.. \
    file://0011-mpm-HwmonTempSensors-fix-double-listed-temp-sensors-.patch;patchdir=.. \
    file://0012-mpm-bist-fix-temp-and-fan-tests-for-e320-n3xx-x4xx.patch;patchdir=.. \
    file://0013-x4xx_bist-Change-retval-for-tests-not-running.patch;patchdir=.. \
    "
