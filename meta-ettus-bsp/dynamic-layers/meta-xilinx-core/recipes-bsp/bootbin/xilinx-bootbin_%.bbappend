DEPENDS:remove:ni-titanium = "device-tree"
DEPENDS:append:ni-titanium = " virtual/dtb"

XILINX_BOOTBIN_DIR = "/uboot"
XILINX_BOOTBIN_NAME = "boot.bin"

do_compile:prepend:ni-titanium() {
    if [ -n "${BOOTGEN_KEYS_PATH}" ]; then
        ln -sfn ${BOOTGEN_KEYS_PATH}/psk0.pem ${WORKDIR}/${PN}-${PV}/psk0.pem
        ln -sfn ${BOOTGEN_KEYS_PATH}/ssk0.pem ${WORKDIR}/${PN}-${PV}/ssk0.pem
    fi
}

do_compile:append:ni-titanium() {
    if [ -n "${BOOTGEN_KEYS_PATH}" ]; then
        bootgen -arch ${BOOTGEN_ARCH} -verify ${B}/BOOT.bin
    fi
}

do_install:ni-titanium() {
    install -d ${D}${XILINX_BOOTBIN_DIR}
    install -m 0644 ${B}/BOOT.bin ${D}${XILINX_BOOTBIN_DIR}/${XILINX_BOOTBIN_NAME}
}

FILES:${PN}:ni-titanium = "${XILINX_BOOTBIN_DIR}/${XILINX_BOOTBIN_NAME}"
SYSROOT_DIRS:ni-titanium = "${XILINX_BOOTBIN_DIR}"
