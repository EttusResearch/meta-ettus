require uhd_4.9_src.inc
require mpmd.inc

LIC_FILES_CHKSUM = "file://../host/LICENSE;md5=8255adf1069294c928e0e18b01a16282"

SRC_URI += " file://0001-mpm-rfdc-applied-patch-to-fix-C-compilation-issue.patch;patchdir=.. \
             file://0002-mpm-adopt-sys_utils.gpio-to-gpiod-version-2.0.2.patch;patchdir=.. \
             file://0003-mpm-sys_utils-linting.patch;patchdir=.. \
             file://0004-mpm-adopt-sys_utils.net-to-pyroute2-version-0.7.0.patch;patchdir=.. \
             file://0005-mpm-include-missing-header-in-mykonos-lib.patch;patchdir=.. \
             file://0006-mpm-sys_utils.i2c_dev-rework-e.g.-don-t-rely-on-i2c-.patch;patchdir=.. \
            "
