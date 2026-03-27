FILESEXTRAPATHS:prepend:ni-titanium := "${THISDIR}/files:"

# Don't run mender autoconfiguration for u-boot ...
MENDER_UBOOT_AUTO_CONFIGURE = "0"

# ... instead use our own patches.
#
# Patch application order (all :ni-titanium-mender patches come after the
# board patches from meta-ettus-bsp and the generic mender patches from
# meta-mender-core):
#
#   0001 - (meta-mender-core) Creates include/env_mender.h and
#           include/config_mender.h.
#   0002 - (meta-mender-core, file OVERRIDDEN by this layer via FILESEXTRAPATHS)
#           Integrates env_mender.h into env_default.h and config_mender.h into
#           Makefile.autoconf. The override in ${THISDIR}/files/ adapts the
#           patch to U-Boot v2026.01 API changes: generated/environment.h,
#           CONFIG_ENV_USE_DEFAULT_ENV_TEXT_FILE, const char, updated
#           Makefile.autoconf context line numbers.
#           NOTE: Do NOT list 0002 here — meta-mender-core already adds it via
#           SRC_URI:append:mender-uboot; FILESEXTRAPATHS ensures our version
#           is picked up automatically.
#
#   0043 - Adds CONFIG_ENV_REDUNDANT=y and CONFIG_ENV_OFFSET_REDUND=0x1000000
#           to ni_x410_rev5_defconfig. Patch 0039 (in meta-ettus-bsp) created
#           the rev5 defconfig without these settings; patch 0028 added them
#           to rev2/3/4 only. Without CONFIG_ENV_REDUNDANT the Kconfig-gated
#           dual-env code in env_internal.h is never compiled in, even though
#           config_mender.h's CPP check for CONFIG_SYS_REDUNDAND_ENVIRONMENT
#           passes.
#   0010 - Wires mender_setup / ${mender_uboot_root} / ${mender_kernel_root}
#           into the emmcboot and sdboot commands in ni-x410.h.
#   0011 - Renames CONFIG_MENDER_BOOTCOMMAND -> MENDER_BOOTCOMMAND in
#           env_mender.h to avoid the "ad-hoc CONFIG_ option" Kconfig error.
SRC_URI:append:ni-titanium-mender = " \
    file://0001-Add-altbootcmd-which-was-missing.patch \
    file://0043-configs-ni_x410_rev5-add-redundant-env-for-Mender.patch \
    file://0010-x410-update-config-for-Mender.patch \
    file://0011-include-env_mender-rename-CONFIG_MENDER_BOOTCOMMAND.patch \
    "

# do_provide_mender_defines:append:ni-titanium-mender() {
#   # fix boot command when using fitImage:
#   # MENDER_KERNEL_IMAGETYPE=fitImage leads to MENDER_BOOT_KERNEL_TYPE=bootz
#   # which is wrong, set it to bootm instead
#   sed -i "s|^\(#define MENDER_BOOT_KERNEL_TYPE\).*$|\1 \"bootm\"|" ${S}/include/config_mender_defines.h
# }
