FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Don't run mender autoconfiguration for u-boot ...
MENDER_UBOOT_AUTO_CONFIGURE = "0"

# ... instead use our own patches
SRC_URI_append_ni-e31x-mender = " \
    file://0001-ni-zynq-Mender.io-support-for-NI-Ettus-Research-E31x.patch \
    file://0003-Remove-CONFIG_SYS_REDUNDAND_ENVIRONMENT-check.patch \
    "

# Don't overwrite variable bootcommand with CONFIG_MENDER_BOOTCOMMAND
# instead, variable sdboot is patched by our own patch
SRC_URI_remove_ni-e31x-mender = "file://0004-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch"

do_provide_mender_defines_append_ni-e31x-mender() {
  # fix boot command when using fitImage:
  # MENDER_KERNEL_IMAGETYPE=fitImage leads to MENDER_BOOT_KERNEL_TYPE=bootz
  # which is wrong, set it to bootm instead
  sed -i "s|^\(#define MENDER_BOOT_KERNEL_TYPE\).*$|\1 \"bootm\"|" ${S}/include/config_mender_defines.h
}

#
# FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
#
# # Make sure this is an append, otherwise this might get applied before the BSP patches
# SRC_URI_append_ni-e31x-mender = " \
#            file://0002-ni-zynq-Mender.io-support-for-NI-Ettus-Research-E31x.patch \
#            "
