inherit uhd_images_downloader

EXTRA_PACKAGES_ni-e31x-sg1 ?= " \
    ${PN}-e310-sg1 \
    ${PN}-inventory \
"
EXTRA_PACKAGES_ni-e31x-sg3 ?= " \
    ${PN}-e310-sg3 \
    ${PN}-inventory \
"

PACKAGES_append_ni-e31x-sg1 = " \
    ${EXTRA_PACKAGES} \
    ${PN}-e310-sg1-firmware \
    "
PACKAGES_append_ni-e31x-sg3 = " \
    ${EXTRA_PACKAGES} \
    ${PN}-e310-sg3-firmware \
    "

RDEPENDS_${PN}_ni-e31x-sg1 += "${EXTRA_PACKAGES}"
RDEPENDS_${PN}_ni-e31x-sg3 += "${EXTRA_PACKAGES}"
RDEPENDS_${PN}-firmware_append_ni-e31x-sg1 = " \
    ${PN}-e310-sg1-firmware \
    "
RDEPENDS_${PN}-firmware_append_ni-e31x-sg3 = " \
    ${PN}-e310-sg3-firmware \
    "

FILES_${PN}-e310-sg1 = "${UHD_IMAGES_INSTALL_PATH}/usrp_e310_sg1_*.*"
FILES_${PN}-e310-sg3 = "${UHD_IMAGES_INSTALL_PATH}/usrp_e310_sg3_*.*"
FILES_${PN}-inventory = "${UHD_IMAGES_INSTALL_PATH}/inventory.json"
FILES_${PN}-e310-sg1-firmware = " \
    /lib/firmware/e310_sg1.bin \
    /lib/firmware/e310_sg1.dtbo \
    /lib/firmware/e310_sg1_idle.bin \
    /lib/firmware/e310_sg1_idle.dtbo \
    "
FILES_${PN}-e310-sg3-firmware = " \
    /lib/firmware/e310_sg3.bin \
    /lib/firmware/e310_sg3.dtbo \
    /lib/firmware/e310_sg3_idle.bin \
    /lib/firmware/e310_sg3_idle.dtbo \
    "

UHD_IMAGES_TO_DOWNLOAD_ni-e31x-sg1 ?= " \
    e3xx_e310_sg1_fpga_default \
    "
UHD_IMAGES_TO_DOWNLOAD_ni-e31x-sg3 ?= " \
    e3xx_e310_sg3_fpga_default \
    "

UHD_FPGA_IMAGES_IN_FIRMWARE_ni-e31x-sg1 ?= " \
    usrp_e310_sg1_fpga \
    usrp_e310_sg1_idle_fpga \
    "
UHD_FPGA_IMAGES_IN_FIRMWARE_ni-e31x-sg3 ?= " \
    usrp_e310_sg3_fpga \
    usrp_e310_sg3_idle_fpga \
    "

do_install_append_ni-e31x-sg1() {
    mkdir -p ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_e310_sg1_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}

    mv ${D}/lib/firmware/usrp_e310_sg1_fpga.bin ${D}/lib/firmware/e310_sg1.bin
    mv ${D}/lib/firmware/usrp_e310_sg1_fpga.dtbo ${D}/lib/firmware/e310_sg1.dtbo
    mv ${D}/lib/firmware/usrp_e310_sg1_idle_fpga.bin ${D}/lib/firmware/e310_sg1_idle.bin
    mv ${D}/lib/firmware/usrp_e310_sg1_idle_fpga.dtbo ${D}/lib/firmware/e310_sg1_idle.dtbo
}

do_install_append_ni-e31x-sg3() {
    mkdir -p ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_e310_sg3_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}

    mv ${D}/lib/firmware/usrp_e310_sg3_fpga.bin ${D}/lib/firmware/e310_sg3.bin
    mv ${D}/lib/firmware/usrp_e310_sg3_fpga.dtbo ${D}/lib/firmware/e310_sg3.dtbo
    mv ${D}/lib/firmware/usrp_e310_sg3_idle_fpga.bin ${D}/lib/firmware/e310_sg3_idle.bin
    mv ${D}/lib/firmware/usrp_e310_sg3_idle_fpga.dtbo ${D}/lib/firmware/e310_sg3_idle.dtbo
}
