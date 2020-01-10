inherit uhd_images_downloader

EXTRA_PACKAGES_ni-sulfur ?= " \
    ${PN}-n300 \
    ${PN}-n310 \
    ${PN}-n320 \
    ${PN}-inventory \
    "

PACKAGES_append_ni-sulfur = " \
    ${EXTRA_PACKAGES} \
    ${PN}-n300-firmware \
    ${PN}-n310-firmware \
    ${PN}-n320-firmware \
    "
RDEPENDS_${PN}_ni-sulfur = "${EXTRA_PACKAGES}"
RDEPENDS_${PN}-firmware_append_ni-sulfur = " \
    ${PN}-n300-firmware \
    ${PN}-n310-firmware \
    ${PN}-n320-firmware \
    "

RPROVIDES_${PN}-n300 = "${PN}-phosphorus"
RPROVIDES_${PN}-n310 = "${PN}-sulfur"
RPROVIDES_${PN}-n320 = "${PN}-rhodium"

RPROVIDES_${PN}-n300-firmware = "${PN}-phosphorus-firmware"
RPROVIDES_${PN}-n310-firmware = "${PN}-sulfur-firmware"
RPROVIDES_${PN}-n320-firmware = "${PN}-rhodium-firmware"

FILES_${PN}-n300 = "${UHD_IMAGES_INSTALL_PATH}/usrp_n300_*.*"
FILES_${PN}-n310 = "${UHD_IMAGES_INSTALL_PATH}/usrp_n310_*.*"
FILES_${PN}-n320 = "${UHD_IMAGES_INSTALL_PATH}/usrp_n320_*.*"
FILES_${PN}-inventory = "${UHD_IMAGES_INSTALL_PATH}/inventory.json"
FILES_${PN}-n300-firmware = " \
    /lib/firmware/n300.bin \
    /lib/firmware/n300.dtbo \
    "
FILES_${PN}-n310-firmware = " \
    /lib/firmware/n310.bin \
    /lib/firmware/n310.dtbo \
    "
FILES_${PN}-n320-firmware = " \
    /lib/firmware/n320.bin \
    /lib/firmware/n320.dtbo \
    "

UHD_IMAGES_TO_DOWNLOAD_ni-sulfur ?= " \
    n3xx_n300_fpga_default \
    n3xx_n310_fpga_default \
    n3xx_n320_fpga_default \
    "

UHD_FPGA_IMAGES_IN_FIRMWARE_ni-sulfur ?= " \
    usrp_n300_fpga_HG \
    usrp_n310_fpga_HG \
    usrp_n320_fpga_HG \
    "

do_install_append_ni-sulfur() {
    mkdir -p ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_n300_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_n310_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_n320_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}

    mv ${D}/lib/firmware/usrp_n300_fpga_HG.bin ${D}/lib/firmware/n300.bin
    mv ${D}/lib/firmware/usrp_n300_fpga_HG.dtbo ${D}/lib/firmware/n300.dtbo
    mv ${D}/lib/firmware/usrp_n310_fpga_HG.bin ${D}/lib/firmware/n310.bin
    mv ${D}/lib/firmware/usrp_n310_fpga_HG.dtbo ${D}/lib/firmware/n310.dtbo
    mv ${D}/lib/firmware/usrp_n320_fpga_HG.bin ${D}/lib/firmware/n320.bin
    mv ${D}/lib/firmware/usrp_n320_fpga_HG.dtbo ${D}/lib/firmware/n320.dtbo
}
