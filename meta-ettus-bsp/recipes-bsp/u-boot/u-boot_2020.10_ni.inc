FILESEXTRAPATHS:prepend:ni-titanium := "${THISDIR}/files/ni-titanium:"

SRC_URI:prepend:ni-titanium = " \
                  file://boot_u-boot.tcl \
                  file://boot_u-boot \
                  file://0001-usb-dwc3-Increase-the-timeout-for-generic-commands.patch \
                  file://0002-Revert-mmc-Downgrade-SD-MMC-from-UHS-HS200-HS400-mod.patch \
                  file://0003-misc-cros_ec-Add-trivial-support-for-software-sync.patch \
                  file://0004-board-zynqmp-make-board_late_init-weak.patch \
                  file://0005-zynqmp-added-CONFIG_ZYNQMP_SPL_PM_CFG_OBJ_SRC_FILE.patch \
                  file://0006-board-ni-add-support-for-X410.patch \
                  file://0007-Add-missing-header-which-fails-on-recent-GCC.patch \
                  file://0008-board-ni-add-support-for-X440.patch \
                  "

DEPENDS:append:ni-titanium = " zip-native"

FILES:${PN}:ni-titanium="/uboot /etc"

PMU_FIRMWARE_DEPLOY_DIR:ni-titanium = "${BINARYDIR}/ni-titanium"
PMU_FIRMWARE_IMAGE_NAME:ni-titanium = "pmu-firmware"

do_compile[depends] += "virtual/arm-trusted-firmware:do_deploy"

EXTRA_OEMAKE:append:ni-titanium = " CONFIG_PMUFW_INIT_FILE=${PMU_FIRMWARE_DEPLOY_DIR}/${PMU_FIRMWARE_IMAGE_NAME}.bin"

do_compile:prepend:ni-titanium() {
    # load some variables from the config file
    UBOOT_CONFIGFILE="${S}/configs/${UBOOT_MACHINE}"
    grep -e "^CONFIG_SPL_FIT_SOURCE=" \
      ${UBOOT_CONFIGFILE} > ${B}/config.temp
    . ${B}/config.temp
    # copy ARM Trusted firmware Image: EL3 Runtime Firmware: AP_BL31
    # see https://github.com/ARM-software/arm-trusted-firmware/blob/master/docs/getting_started/image-terminology.rst
    cp ${DEPLOY_DIR_IMAGE}/arm-trusted-firmware.bin ${B}/bl31.bin
    cp ${DEPLOY_DIR_IMAGE}/arm-trusted-firmware.elf ${B}/bl31.elf
    # refernce/copy Platform Management Unit (PMU) Firmware
    # see https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841724/PMU+Firmware
    # note: u-boot-spl-zynq-init.inc from meta-xilinx sets CONFIG_PMUFW_INIT_FILE
    # as EXTRA_OEMAKE option
    echo "using CONFIG_PMUFW_INIT_FILE=${PMU_FIRMWARE_DEPLOY_DIR}/${PMU_FIRMWARE_IMAGE_NAME}.bin"
    cp ${PMU_FIRMWARE_DEPLOY_DIR}/${PMU_FIRMWARE_IMAGE_NAME}.elf \
      ${B}/pmu-firmware.elf
    # copy the CONFIG_SPL_FIT_SOURCE file from the source to the build directory
    # where the Makefile expects it
    mkdir -p $(dirname ${B}/${CONFIG_SPL_FIT_SOURCE})
    cp ${S}/${CONFIG_SPL_FIT_SOURCE} \
      ${B}/${CONFIG_SPL_FIT_SOURCE}
}

do_install:append:ni-titanium() {
	mv ${D}/boot ${D}/uboot
}

CROS_EC_DEPLOY_DIR_IMAGE:ni-titanium ?= "${TOPDIR}/tmp-stm32-baremetal/deploy/images/ni-titanium-ec-rev5"
python __anonymous() {
    if "ni-titanium-ec" in d.getVar('BBMULTICONFIG').split(' '):
        d.appendVarFlag('do_deploy', 'mcdepends', ' mc:ni-titanium:ni-titanium-ec:chromium-ec:do_deploy')
}

do_deploy:append:ni-titanium() {
  # prepare a zip file which includes all necessary files for loading u-boot
  # via JTAG
  UBOOT_JTAG_FILES_TARGET=u-boot-jtag-files-${MACHINE}-${PV}.zip
  UBOOT_JTAG_FILES_SYMLINK1=u-boot-jtag-files-${MACHINE}.zip
  UBOOT_JTAG_FILES_SYMLINK2=u-boot-jtag-files.zip
  zip -j -MM ${DEPLOYDIR}/${UBOOT_JTAG_FILES_TARGET} \
    ${WORKDIR}/boot_u-boot ${WORKDIR}/boot_u-boot.tcl ${B}/pmu-firmware.elf \
    ${B}/spl/u-boot-spl.bin ${B}/bl31.elf ${B}/u-boot.elf \
    ${CROS_EC_DEPLOY_DIR_IMAGE}/ec-titanium-rev*.bin
  ln -sf ${UBOOT_JTAG_FILES_TARGET} ${DEPLOYDIR}/${UBOOT_JTAG_FILES_SYMLINK1}
  ln -sf ${UBOOT_JTAG_FILES_TARGET} ${DEPLOYDIR}/${UBOOT_JTAG_FILES_SYMLINK2}
}

# workarounds to remove the zynqmp-overrides to u-boot because the platform init
# and the PMU firmware are already taken care of by the ni-titanium overrides
DEPENDS:remove:ni-titanium = " virtual/xilinx-platform-init"

do_zynq_platform_init:ni-titanium() {
}
