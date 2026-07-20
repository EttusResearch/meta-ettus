FILESEXTRAPATHS:prepend:ni-titanium := "${THISDIR}/files/ni-titanium:"

SRC_URI:prepend:ni-titanium = " \
                  file://0001-usb-dwc3-Increase-the-timeout-for-generic-commands.patch \
                  file://0002-Revert-mmc-Downgrade-SD-MMC-from-UHS-HS200-HS400-mod.patch \
                  file://0003-misc-cros_ec-Add-trivial-support-for-software-sync.patch \
                  file://0004-board-zynqmp-make-board_late_init-weak.patch \
                  file://0005-zynqmp-added-CONFIG_ZYNQMP_SPL_PM_CFG_OBJ_SRC_FILE.patch \
                  file://0006-board-ni-add-support-for-X410.patch \
                  file://0007-Add-missing-header-which-fails-on-recent-GCC.patch \
                  file://0008-board-ni-add-support-for-X440.patch \
                  file://0009-board-ni-fix-PS-dram-configuration.patch \
                  file://0010-board-ni-add-support-for-X420.patch \
                  "

FILES:${PN}:ni-titanium="/uboot /etc"

do_install:append:ni-titanium() {
	mv ${D}/boot ${D}/uboot
}

# workarounds to remove the zynqmp-overrides to u-boot because the platform init
# and the PMU firmware are already taken care of by the ni-titanium overrides
DEPENDS:remove:ni-titanium = " virtual/xilinx-platform-init"

do_zynq_platform_init:ni-titanium() {
}
