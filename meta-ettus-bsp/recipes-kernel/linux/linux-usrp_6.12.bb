FILESEXTRAPATHS:prepend:ni-titanium := "${THISDIR}/linux-usrp/x4xx-l:"

LIC_FILES_CHKSUM ?= "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

require recipes-kernel/linux/linux-yocto.inc
require kernel-include-nirio-header.inc

KERNEL_VERSION_SANITY_SKIP="1"

KBRANCH = "nilrt/master/6.12"
LINUX_VERSION = "6.12.57-rt14"

# KBUILD_DEFCONFIG ?= "usrp_arm64_defconfig"

SRCREV_machine = "556be4f45e0014252323bd2bb4036129898fc893"
SRCREV_meta = "2987fc4250f2ad7f6e2df663bba0742638fbae51"

DEFCONFIG_FILE:zynq = "usrp_arm_defconfig"
DEFCONFIG_FILE:zynqmp = "usrp_arm64_defconfig"
DEFCONFIG_SUBDIR:zynq="git/arch/arm/configs"
DEFCONFIG_SUBDIR:zynqmp="git/arch/arm64/configs"

LINUX_VERSION_EXTENSION = "-usrp"
KMETA = "kernel-meta"
SRC_URI = " \
    git://github.com/ni/linux;name=machine;protocol=https;branch=${KBRANCH} \
    git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=yocto-6.12;destsuffix=${KMETA};protocol=https \
    file://${DEFCONFIG_FILE};subdir=${DEFCONFIG_SUBDIR} \
    file://usrp.scc \
    file://fix-addressing.cfg \
    file://enable-early-debug.cfg \
    file://sound.cfg \
    "

SRC_URI:append:ni-titanium = " file://x4xx-l.scc"

KCONFIG_MODE = "alldefconfig"
PV = "${LINUX_VERSION}+git${SRCPV}"

KCONF_AUDIT_LEVEL = "2"
KCONF_BSP_AUDIT_LEVEL = "2"

KMACHINE:ni-titanium = "ni-titanium"


COMPATIBLE_MACHINE:ni-e31x = "ni-e31x-sg1|ni-e31x-sg3"
COMPATIBLE_MACHINE:ni-neon = "ni-neon-rev1|ni-neon-rev2"
COMPATIBLE_MACHINE:ni-sulfur = "ni-sulfur-rev3|ni-sulfur-rev4|ni-sulfur-rev5|ni-sulfur-rev6|ni-sulfur-rev11"
COMPATIBLE_MACHINE:ni-titanium = "ni-titanium-rev2|ni-titanium-rev3|ni-titanium-rev4|ni-titanium-rev5"
COMPATIBLE_MACHINE:ni-e31x-mender = "ni-e31x-mender-sg3|ni-e31x-mender-sg1"
COMPATIBLE_MACHINE:ni-neon-mender = "ni-neon-rev1-mender|ni-neon-rev2-mender"
COMPATIBLE_MACHINE:ni-sulfur-mender = "ni-sulfur-rev3-mender|ni-sulfur-rev4-mender|ni-sulfur-rev5-mender|ni-sulfur-rev6-mender"

# Enable DT symbols for overlay support
# KERNEL_DTC_FLAGS += "-@"
FILES:${KERNEL_PACKAGE_NAME}-devicetree += "/usr/lib/firmware/*.dtbo"

do_install:append() {
    install -d ${D}/usr/lib/firmware
    ln -sf /boot/x4xx-db0-db-flash.dtbo ${D}/usr/lib/firmware/db0_flash.dtbo
    ln -sf /boot/x4xx-db1-db-flash.dtbo ${D}/usr/lib/firmware/db1_flash.dtbo
}
