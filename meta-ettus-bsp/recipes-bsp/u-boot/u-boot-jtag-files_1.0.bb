SUMMARY = "U-Boot bootloader fw_printenv/setenv utilities"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

FILESEXTRAPATHS:prepend:= "${THISDIR}/files/ni-titanium:"

COMPATIBLE_MACHINE = "ni-titanium"
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit deploy

DEPENDS = "pmufw fsbl arm-trusted-firmware u-boot virtual/dtb zip-native"

SRC_URI = " \
    file://boot_u-boot \
    file://boot_u-boot.tcl \
    "

UBOOT_JTAG_FILES_TARGET ?= "u-boot-jtag-files-${MACHINE}.zip"
UBOOT_JTAG_FILES_SYMLINK1 ?= "u-boot-jtag-files.zip"

do_compile() {
    cp ${RECIPE_SYSROOT}/boot/pmufw.elf ${B}/pmu-firmware.elf
    cp ${RECIPE_SYSROOT}/boot/fsbl.elf ${B}/fsbl.elf
    cp ${RECIPE_SYSROOT}/boot/arm-trusted-firmware.elf ${B}/bl31.elf
    cp ${RECIPE_SYSROOT}/uboot/u-boot.elf ${B}/u-boot.elf
    cp ${RECIPE_SYSROOT}/boot/system.dtb ${B}/system.dtb
    cp ${WORKDIR}/boot_u-boot ${B}/boot_u-boot
    cp ${WORKDIR}/boot_u-boot.tcl ${B}/boot_u-boot.tcl
    zip -j -MM ${B}/${UBOOT_JTAG_FILES_TARGET} \
        ${B}/pmu-firmware.elf ${B}/fsbl.elf ${B}/bl31.elf ${B}/u-boot.elf \
        ${B}/system.dtb ${B}/boot_u-boot ${B}/boot_u-boot.tcl  
}

addtask deploy after do_compile
do_deploy() {
  install ${B}/${UBOOT_JTAG_FILES_TARGET} ${DEPLOYDIR}/${UBOOT_JTAG_FILES_TARGET}
  ln -sf ${UBOOT_JTAG_FILES_TARGET} ${DEPLOYDIR}/${UBOOT_JTAG_FILES_SYMLINK1}
}
