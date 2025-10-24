inherit uhd_images_downloader

FILES:${PN}:ni-e31x-sg1 = "${UHD_IMAGES_INSTALL_PATH}/usrp_e310_sg1_*.*"
FILES:${PN}:ni-e31x-sg3 = "${UHD_IMAGES_INSTALL_PATH}/usrp_e310_sg3_*.*"
FILES:${PN}-inventory = "${UHD_IMAGES_INSTALL_PATH}/inventory.json"
FILES:${PN}-firmware:ni-e31x-sg1 = " \
    ${libdir}/firmware/e310_sg1.bin \
    ${libdir}/firmware/e310_sg1.dtbo \
    ${libdir}/firmware/e310_sg1_idle.bin \
    ${libdir}/firmware/e310_sg1_idle.dtbo \
    "
FILES:${PN}-firmware:ni-e31x-sg3 = " \
    ${libdir}/firmware/e310_sg3.bin \
    ${libdir}/firmware/e310_sg3.dtbo \
    ${libdir}/firmware/e310_sg3_idle.bin \
    ${libdir}/firmware/e310_sg3_idle.dtbo \
    "

UHD_IMAGES_TO_DOWNLOAD:ni-e31x-sg1 ?= " \
    e3xx_e310_sg1_fpga_default \
    "
UHD_IMAGES_TO_DOWNLOAD:ni-e31x-sg3 ?= " \
    e3xx_e310_sg3_fpga_default \
    "

UHD_FPGA_IMAGES_IN_FIRMWARE:ni-e31x-sg1 ?= " \
    usrp_e310_sg1_fpga \
    usrp_e310_sg1_idle_fpga \
    "
UHD_FPGA_IMAGES_IN_FIRMWARE:ni-e31x-sg3 ?= " \
    usrp_e310_sg3_fpga \
    usrp_e310_sg3_idle_fpga \
    "

do_install:append:ni-e31x-sg1() {
    mkdir -p ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_e310_sg1_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}

    mv ${D}${libdir}/firmware/usrp_e310_sg1_fpga.bin ${D}${libdir}/firmware/e310_sg1.bin
    mv ${D}${libdir}/firmware/usrp_e310_sg1_fpga.dtbo ${D}${libdir}/firmware/e310_sg1.dtbo
    mv ${D}${libdir}/firmware/usrp_e310_sg1_idle_fpga.bin ${D}${libdir}/firmware/e310_sg1_idle.bin
    mv ${D}${libdir}/firmware/usrp_e310_sg1_idle_fpga.dtbo ${D}${libdir}/firmware/e310_sg1_idle.dtbo
}

do_install:append:ni-e31x-sg3() {
    mkdir -p ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_e310_sg3_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}

    mv ${D}${libdir}/firmware/usrp_e310_sg3_fpga.bin ${D}${libdir}/firmware/e310_sg3.bin
    mv ${D}${libdir}/firmware/usrp_e310_sg3_fpga.dtbo ${D}${libdir}/firmware/e310_sg3.dtbo
    mv ${D}${libdir}/firmware/usrp_e310_sg3_idle_fpga.bin ${D}${libdir}/firmware/e310_sg3_idle.bin
    mv ${D}${libdir}/firmware/usrp_e310_sg3_idle_fpga.dtbo ${D}${libdir}/firmware/e310_sg3_idle.dtbo
}
