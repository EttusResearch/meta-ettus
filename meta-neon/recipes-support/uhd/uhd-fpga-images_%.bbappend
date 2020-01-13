inherit uhd_images_downloader

EXTRA_PACKAGES_ni-neon ?= " \
    ${PN}-e320 \
    ${PN}-inventory \
"

PACKAGES_append_ni-neon = " \
    ${EXTRA_PACKAGES} \
    ${PN}-e320-firmware \
    "
RDEPENDS_${PN}_ni-neon += "${EXTRA_PACKAGES}"
RDEPENDS_${PN}-firmware_append_ni-neon = " \
    ${PN}-e320-firmware \
    "

RPROVIDES_${PN}-e320 = "${PN}-neon"

FILES_${PN}-e320 = "${UHD_IMAGES_INSTALL_PATH}/usrp_e320_*.*"
FILES_${PN}-inventory = "${UHD_IMAGES_INSTALL_PATH}/inventory.json"
FILES_${PN}-e320-firmware = " \
    /lib/firmware/e320.bin \
    /lib/firmware/e320.dtbo \
    "

UHD_IMAGES_TO_DOWNLOAD_ni-neon ?= " \
    e3xx_e320_fpga_default \
    "

UHD_FPGA_IMAGES_IN_FIRMWARE_ni-neon ?= " \
    usrp_e320_fpga_1G \
    "

do_install_append_ni-neon() {
    mkdir -p ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_e320_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}

    mv ${D}/lib/firmware/usrp_e320_fpga_1G.bin ${D}/lib/firmware/e320.bin
    mv ${D}/lib/firmware/usrp_e320_fpga_1G.dtbo ${D}/lib/firmware/e320.dtbo
}
