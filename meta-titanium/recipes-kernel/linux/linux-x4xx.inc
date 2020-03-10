LIC_FILES_CHKSUM ?= "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

require recipes-kernel/linux/linux-yocto.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " \
    file://x4xx.scc \
    file://x410_defconfig;subdir=git/arch/arm64/configs \
    "

KERNEL_VERSION_SANITY_SKIP="1"

LINUX_VERSION_EXTENSION = "-x4xx"
SRC_URI_ni-titanium = "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git;branch=${KBRANCH}"
COMPATIBLE_MACHINE_ni-titanium = "ni-titanium-rev2|ni-titanium-rev3|ni-titanium-rev4|ni-titanium-rev5"
KMACHINE_ni-titanium = "ni-titanium"
KCONFIG_MODE ?= "--alldefconfig"
PV = "${LINUX_VERSION}+git${SRCPV}"

KCONF_BSP_AUDIT_LEVEL = "2"

FILES_${KERNEL_PACKAGE_NAME}-devicetree += "/lib/firmware/*.dtbo"

do_install_append() {
    install -d ${D}/lib/firmware
    ln -sf /boot/x4xx-db0-db-flash.dtbo ${D}/lib/firmware/db0_flash.dtbo
    ln -sf /boot/x4xx-db1-db-flash.dtbo ${D}/lib/firmware/db1_flash.dtbo
}
