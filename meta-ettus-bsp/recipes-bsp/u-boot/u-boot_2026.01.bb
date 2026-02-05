# Merged from:
# - u-boot-common-2026.01.inc
# - u-boot_2026.01.bb
# - u-boot_2026.01_ni.inc

# ============================================================================
# u-boot-common-2026.01.inc
# ============================================================================
HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
DESCRIPTION = "U-Boot, a boot loader for Embedded boards based on PowerPC, \
ARM, MIPS and several other processors, which can be installed in a boot \
ROM and used to initialize and test the hardware or to download and run \
application code."
SECTION = "bootloaders"
# DEPENDS += " flex-native bison-native gnutls-native python3-native swig-native python3-dtc-native"
DEPENDS += " flex-native bison-native gnutls-native python3-native swig-native python3-pyelftools-native"

# python3-libfdt-native

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=2ca5f2c35c8cc335f0a19756634782f1"
PE = "1"

# For externalsrc builds, source location is set via EXTERNALSRC
# No SRC_URI or SRCREV needed - source comes from external directory
S = "${WORKDIR}/git"


# ============================================================================
# u-boot_2026.01.bb
# ============================================================================

require u-boot.inc

# Set UBOOT_ELF to the actual compiled binary name
# In u-boot 2026.01, the ELF is built as "u-boot" instead of "u-boot.elf"
# Using machine override to override the aarch64 setting in ni-titanium.inc
UBOOT_ELF:aarch64 = "u-boot"

DEPENDS += " bc-native dtc-native"

# Version for this external build
# U-Boot Version Definition

## Overview
# Sets the package version for U-Boot with Git revision tracking.

## Variables Explained

### PV (Package Version)
# The version string used by the BitBake build system to identify the package. 
# It's displayed in package managers and build logs.

### SRCPV (Source Revision)
# A BitBake variable that automatically expands to the Git revision information 
# (commit hash) from the source repository. Provides precise version tracking 
# for development builds.

### Git Format: `2026.01+git${SRCPV}`
# - `2026.01` - The base U-Boot release version
# - `+git` - Literal text indicating a Git-based build
# - `${SRCPV}` - Expands to Git commit metadata (e.g., `r12345abcde`)

## Purpose
# Enables precise version identification for development and testing builds 
# by embedding the actual Git commit hash in the package version string, 
# allowing traceability of exact source code used in builds.
PV = "2026.01+git${SRCPV}"

# Note: This recipe is designed to work with externalsrc
# Configure via kas include file or local.conf:
#   INHERIT += "externalsrc"
#   EXTERNALSRC:pn-u-boot = "${TOPDIR}/../u-boot-dev"
#   EXTERNALSRC_BUILD:pn-u-boot = "${TOPDIR}/../u-boot-dev"

# ============================================================================
# u-boot_2026.01_ni.inc
# ============================================================================
FILESEXTRAPATHS:prepend:ni-titanium := "${THISDIR}/files/ni-titanium:"

# For externalsrc builds, patches and source files are not applied
# All modifications should be in the external source tree
# Keeping this file for potential runtime configuration overrides

DEPENDS:append:ni-titanium = " zip-native"

FILES:${PN}:ni-titanium="/uboot /etc"

PMU_FIRMWARE_DEPLOY_DIR:ni-titanium = "${BINARYDIR}/ni-titanium"
PMU_FIRMWARE_IMAGE_NAME:ni-titanium = "pmu-firmware"

do_compile[depends] += "virtual/arm-trusted-firmware:do_deploy"

EXTRA_OEMAKE:append:ni-titanium = " CONFIG_PMUFW_INIT_FILE=${PMU_FIRMWARE_DEPLOY_DIR}/${PMU_FIRMWARE_IMAGE_NAME}.bin"
# Add Python include directory to HOSTCFLAGS for building pylibfdt
# EXTRA_OEMAKE:append:ni-titanium = " HOSTCFLAGS='${BUILD_CFLAGS} -I${STAGING_INCDIR_NATIVE}/python3.12'"

# do_compile:prepend:ni-titanium()
#
# Purpose:
#   Prepare required firmware/artifacts in the u-boot build directory (${B})
#   before the u-boot compile step for the "ni-titanium" machine. Ensures
#   SPL/FIT and platform-specific firmware are available where the u-boot
#   Makefile expects them.
#
# Actions performed:
#   - Extracts CONFIG_SPL_FIT_SOURCE (if present) from the U-Boot config file
#     (${S}/configs/${UBOOT_MACHINE}) by grepping into a temp file and sourcing it.
#     (Grepping failure is tolerated so the build doesn't abort if not present.)
#   - Copies ARM Trusted Firmware (EL3 runtime / BL31) images from the deploy
#     image directory to the build directory as bl31.bin and bl31.elf so they
#     can be packaged into the final image or referenced by SPL/FIT.
#   - Logs and copies the Platform Management Unit (PMU) firmware ELF into the
#     build directory as pmu-firmware.elf using the PMU_FIRMWARE_* variables
#     provided by the surrounding recipes/meta layers.
#   - If CONFIG_SPL_FIT_SOURCE was defined, creates the necessary target
#     directory under ${B} and copies that source file from ${S} into ${B}
#     so the U-Boot build system can include it in an SPL/FIT image.
#
# Notes / Rationale:
#   - Files are staged into ${B} because u-boot's Makefile expects firmware
#     blobs and fit sources to be present in the build directory during compile.
#   - The grep-and-source pattern is used to import a specific config macro
#     from the U-Boot defconfig without parsing the entire file in BitBake.
#   - This is a prepend to do_compile and runs on the ni-titanium machine only,
#     ensuring machine-specific firmware handling does not affect other targets.

do_compile:prepend:ni-titanium() {
    # load some variables from the config file
    UBOOT_CONFIGFILE="${S}/configs/${UBOOT_MACHINE}"
    grep -e "^CONFIG_SPL_FIT_SOURCE=" \
      ${UBOOT_CONFIGFILE} > ${B}/config.temp || true
    . ${B}/config.temp
    # copy ARM Trusted firmware Image: EL3 Runtime Firmware: AP_BL31
    # see https://github.com/ARM-software/arm-trusted-firmware/blob/master/docs/getting_started/image-terminology.rst
    cp ${DEPLOY_DIR_IMAGE}/arm-trusted-firmware.bin ${B}/bl31.bin
    cp ${DEPLOY_DIR_IMAGE}/arm-trusted-firmware.elf ${B}/bl31.elf
    # reference/copy Platform Management Unit (PMU) Firmware
    # see https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841724/PMU+Firmware
    # note: u-boot-spl-zynq-init.inc from meta-xilinx sets CONFIG_PMUFW_INIT_FILE
    # as EXTRA_OEMAKE option
    echo "using CONFIG_PMUFW_INIT_FILE=${PMU_FIRMWARE_DEPLOY_DIR}/${PMU_FIRMWARE_IMAGE_NAME}.bin"
    cp ${PMU_FIRMWARE_DEPLOY_DIR}/${PMU_FIRMWARE_IMAGE_NAME}.elf \
      ${B}/pmu-firmware.elf
    # copy the CONFIG_SPL_FIT_SOURCE file from the source to the build directory
    # where the Makefile expects it (only if CONFIG_SPL_FIT_SOURCE is defined)
    if [ -n "${CONFIG_SPL_FIT_SOURCE}" ]; then
        mkdir -p $(dirname ${B}/${CONFIG_SPL_FIT_SOURCE})
        cp ${S}/${CONFIG_SPL_FIT_SOURCE} \
          ${B}/${CONFIG_SPL_FIT_SOURCE}
    fi
}

do_install:append:ni-titanium() {
	mv ${D}/boot ${D}/uboot
}

CROS_EC_DEPLOY_DIR_IMAGE:ni-titanium ?= "${TOPDIR}/tmp-stm32-baremetal/deploy/images/ni-titanium-ec-rev5"
python __anonymous() {
    if "ni-titanium-ec" in (d.getVar('BBMULTICONFIG') or "").split(' '):
        d.appendVarFlag('do_deploy', 'mcdepends', ' mc:ni-titanium:ni-titanium-ec:chromium-ec:do_deploy')
}

do_deploy:append:ni-titanium() {
  # prepare a zip file which includes all necessary files for loading u-boot
  # via JTAG
  UBOOT_JTAG_FILES_TARGET=u-boot-jtag-files-${MACHINE}-${PV}.zip
  UBOOT_JTAG_FILES_SYMLINK1=u-boot-jtag-files-${MACHINE}.zip
  UBOOT_JTAG_FILES_SYMLINK2=u-boot-jtag-files.zip
  zip -j -MM ${DEPLOYDIR}/${UBOOT_JTAG_FILES_TARGET} \
    ${B}/pmu-firmware.elf \
    ${B}/spl/u-boot-spl.bin ${B}/bl31.elf ${B}/${UBOOT_ELF} \
    ${CROS_EC_DEPLOY_DIR_IMAGE}/ec-titanium-rev*.bin
  ln -sf ${UBOOT_JTAG_FILES_TARGET} ${DEPLOYDIR}/${UBOOT_JTAG_FILES_SYMLINK1}
  ln -sf ${UBOOT_JTAG_FILES_TARGET} ${DEPLOYDIR}/${UBOOT_JTAG_FILES_SYMLINK2}
}

# workarounds to remove the zynqmp-overrides to u-boot because the platform init
# and the PMU firmware are already taken care of by the ni-titanium overrides
DEPENDS:remove:ni-titanium = " virtual/xilinx-platform-init"

do_zynq_platform_init:ni-titanium() {
}