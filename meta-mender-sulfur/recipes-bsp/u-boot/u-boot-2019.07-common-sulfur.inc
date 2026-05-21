FILESEXTRAPATHS:prepend:ni-sulfur-mender := "${THISDIR}/files:"

# Don't run mender autoconfiguration for u-boot ...
MENDER_UBOOT_AUTO_CONFIGURE = "0"

# ... instead use our own patches
SRC_URI:append:ni-sulfur-mender = " \
           file://0001-ni-zynq-Mender.io-support-for-NI-Ettus-Research-Sulf.patch \
           file://0003-Remove-CONFIG_SYS_REDUNDAND_ENVIRONMENT-check.patch \
           file://0002-Integration-of-Mender-boot-code-into-U-Boot-N3XX.patch \
"

# Don't overwrite variable bootcommand with CONFIG_MENDER_BOOTCOMMAND
# instead, variable sdboot is patched by our own patch
# Also replace the mender-core 0002 patch with a local version that has
# correct context lines for this u-boot tree (avoids QA fuzz error).
SRC_URI:remove:ni-sulfur-mender = "file://0004-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch file://0002-Integration-of-Mender-boot-code-into-U-Boot.patch"

do_provide_mender_defines:append:ni-sulfur-mender() {
  # fix boot command when using fitImage:
  # MENDER_KERNEL_IMAGETYPE=fitImage leads to MENDER_BOOT_KERNEL_TYPE=bootz
  # which is wrong, set it to bootm instead
  sed -i "s|^\(#define MENDER_BOOT_KERNEL_TYPE\).*$|\1 \"bootm\"|" ${S}/include/config_mender_defines.h
}
