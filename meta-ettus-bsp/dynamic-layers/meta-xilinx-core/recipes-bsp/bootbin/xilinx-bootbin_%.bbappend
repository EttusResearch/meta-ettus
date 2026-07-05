DEPENDS:remove:ni-titanium = "device-tree"
DEPENDS:append:ni-titanium = " virtual/dtb"

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
    install -d ${D}${BOOTBIN_DIR}
    install -m 0644 ${B}/BOOT.bin ${D}${BOOTBIN_DIR}/${BOOTBIN_NAME}
}

do_deploy:ni-titanium() {
    install -d ${DEPLOYDIR}
    install -m 0644 ${B}/BOOT.bin ${DEPLOYDIR}/${BOOTBIN_BASE_NAME}.bin
    ln -sf ${BOOTBIN_BASE_NAME}.bin ${DEPLOYDIR}/${BOOTBIN_LINK_NAME}.bin
    ln -sf ${BOOTBIN_BASE_NAME}.bin ${DEPLOYDIR}/${BOOTBIN_NAME}

    install -d ${DEPLOYDIR}/boot.bin-extracted
    install -m 0644 ${B}/* ${DEPLOYDIR}/boot.bin-extracted/.
    rm -f ${DEPLOYDIR}/boot.bin-extracted/BOOT.bin
}

FILES:${PN}:ni-titanium = "${BOOTBIN_DIR}/${BOOTBIN_NAME}"
SYSROOT_DIRS:ni-titanium = "${BOOTBIN_DIR}"
