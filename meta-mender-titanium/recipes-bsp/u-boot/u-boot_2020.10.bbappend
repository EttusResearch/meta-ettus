FILESEXTRAPATHS:prepend:ni-titanium := "${THISDIR}/files:"

# Don't run mender autoconfiguration for u-boot ...
MENDER_UBOOT_AUTO_CONFIGURE = "0"

# ... instead use our own patches
SRC_URI:append:ni-titanium-mender = " \
    file://0010-x410-update-config-for-Mender.patch \
    file://0011-include-env_mender-rename-CONFIG_MENDER_BOOTCOMMAND.patch \
                                    "
# do_provide_mender_defines:append:ni-titanium-mender() {
#   # fix boot command when using fitImage:
#   # MENDER_KERNEL_IMAGETYPE=fitImage leads to MENDER_BOOT_KERNEL_TYPE=bootz
#   # which is wrong, set it to bootm instead
#   sed -i "s|^\(#define MENDER_BOOT_KERNEL_TYPE\).*$|\1 \"bootm\"|" ${S}/include/config_mender_defines.h
# }
