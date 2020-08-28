require recipes-support/uhd/mpmd.inc
require recipes-support/uhd/uhd_3.15_src.inc

LIC_FILES_CHKSUM = "file://../host/LICENSE;md5=8255adf1069294c928e0e18b01a16282"

SRC_URI_append = " \
    file://0001-mpm-Add-compile-flag-to-fix-missing-definition.patch;striplevel=2 \
    file://0001-mpm-catalina-Add-thread.cpp-from-UHD-to-included-fil.patch;patchdir=${S}/.. \
    file://0002-mpm-cmake-added-date_time-as-required-boost-componen.patch;patchdir=${S}/.. \
    file://0003-mpm-explicitly-set-max-buffer-size-for-msgpack-unpac.patch;patchdir=${S}/.. \
    file://0004-mpm-rpc_server-set-correct-default-unpacker-params-f.patch;patchdir=${S}/.. \
    "
