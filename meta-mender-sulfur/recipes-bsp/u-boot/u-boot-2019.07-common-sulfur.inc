FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Don't run mender autoconfiguration for u-boot ...
MENDER_UBOOT_AUTO_CONFIGURE = "0"

# ... instead use our own patches
SRC_URI_append_ni-sulfur-mender = " \
           file://0001-ni-zynq-Mender.io-support-for-NI-Ettus-Research-Sulf.patch \
"
# Don't overwrite variable bootcommand with CONFIG_MENDER_BOOTCOMMAND
# instead, variable sdboot is patched by our own patch
SRC_URI_remove_ni-sulfur-mender = "file://0004-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch"

do_provide_mender_defines_append_ni-sulfur-mender() {
  # fix boot command when using fitImage:
  # MENDER_KERNEL_IMAGETYPE=fitImage leads to MENDER_BOOT_KERNEL_TYPE=bootz
  # which is wrong, set it to bootm instead
  sed -i "s|^\(#define MENDER_BOOT_KERNEL_TYPE\).*$|\1 \"bootm\"|" ${S}/include/config_mender_defines.h
}
