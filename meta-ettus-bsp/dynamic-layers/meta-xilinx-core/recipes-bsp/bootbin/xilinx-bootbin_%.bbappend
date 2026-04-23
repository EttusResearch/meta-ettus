DEPENDS:remove:ni-titanium = "device-tree"
DEPENDS:append:ni-titanium = " virtual/dtb"

XILINX_BOOTBIN_DIR = "/uboot"
XILINX_BOOTBIN_NAME = "boot.bin"

do_install:ni-titanium() {
    install -d ${D}${XILINX_BOOTBIN_DIR}
    install -m 0644 ${B}/BOOT.bin ${D}${XILINX_BOOTBIN_DIR}/${XILINX_BOOTBIN_NAME}
}

FILES:${PN}:ni-titanium = "${XILINX_BOOTBIN_DIR}/${XILINX_BOOTBIN_NAME}"
SYSROOT_DIRS:ni-titanium = "${XILINX_BOOTBIN_DIR}"
