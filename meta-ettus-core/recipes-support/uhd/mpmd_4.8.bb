require uhd_4.8_src.inc
require mpmd.inc

LIC_FILES_CHKSUM = "file://../host/LICENSE;md5=8255adf1069294c928e0e18b01a16282"

SRC_URI += "file://0000-mpm-rpc_server-cast-get_device_info-get_mbeeprom-par.patch;patchdir=.. \
            file://0000-mpm-get_mender_artifact-fix-obsolete-command.patch;patchdir=.. \
            file://0001-mpm-tdc-fix-compatibility-with-Python-3.9.0.patch;patchdir=.. \
            file://0002-mpm-deactivate-Duplicate-Address-Detection-DAD-on-in.patch;patchdir=.. \
            file://0003-mpm-usrp_update_fs-correct-outdated-mender-command-i.patch;patchdir=.. \
            file://0004-mpm-avoid-importing-from-rpc_server-when-importing-u.patch;patchdir=.. \
           "
