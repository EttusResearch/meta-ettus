FILESEXTRAPATHS_prepend_ni-titanium := "${THISDIR}/files:"

# Don't run mender autoconfiguration for u-boot ...
MENDER_UBOOT_AUTO_CONFIGURE = "0"

# ... instead use our own patches
SRC_URI_append_ni-titanium-mender = " \
    file://0008-Generic-boot-code-for-Mender.patch \
    file://0009-Integration-of-Mender-boot-code-into-U-Boot.patch \
    file://0010-x410-update-config-for-Mender.patch \
    file://0011-include-env_mender-rename-CONFIG_MENDER_BOOTCOMMAND.patch \
                                    "
# Don't overwrite variable bootcommand with CONFIG_MENDER_BOOTCOMMAND
# instead, variable emmcboot is patched by our own patch
SRC_URI_remove_ni-titanium-mender = "file://0001-Add-missing-header-which-fails-on-recent-GCC.patch"
SRC_URI_remove_ni-titanium-mender = "file://0002-Generic-boot-code-for-Mender.patch"
SRC_URI_remove_ni-titanium-mender = "file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI_remove_ni-titanium-mender = "file://0004-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch"

do_provide_mender_defines_append_ni-titanium-mender() {
  # fix boot command when using fitImage:
  # MENDER_KERNEL_IMAGETYPE=fitImage leads to MENDER_BOOT_KERNEL_TYPE=bootz
  # which is wrong, set it to bootm instead
  sed -i "s|^\(#define MENDER_BOOT_KERNEL_TYPE\).*$|\1 \"bootm\"|" ${S}/include/config_mender_defines.h
}
