inherit uhd_images_downloader

FILES:${PN}:ni-sulfur = " \
    ${UHD_IMAGES_INSTALL_PATH}/usrp_n300_*.* \
    ${UHD_IMAGES_INSTALL_PATH}/usrp_n310_*.* \
    ${UHD_IMAGES_INSTALL_PATH}/usrp_n320_*.* \
    "
FILES:${PN}-inventory:ni-sulfur = "${UHD_IMAGES_INSTALL_PATH}/inventory.json"
FILES:${PN}-firmware:ni-sulfur = " \
    ${libdir}/firmware/n300.bin \
    ${libdir}/firmware/n300.dtbo \
    ${libdir}/firmware/n310.bin \
    ${libdir}/firmware/n310.dtbo \
    ${libdir}/firmware/n320.bin \
    ${libdir}/firmware/n320.dtbo \
    "

UHD_IMAGES_TO_DOWNLOAD:ni-sulfur ?= " \
    n3xx_n300_fpga_default \
    n3xx_n310_fpga_default \
    n3xx_n320_fpga_default \
    "

UHD_FPGA_IMAGES_IN_FIRMWARE:ni-sulfur ?= " \
    usrp_n300_fpga_HG \
    usrp_n310_fpga_HG \
    usrp_n320_fpga_HG \
    "

do_install:append:ni-sulfur() {
    mkdir -p ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_n300_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_n310_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_n320_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}

    mv ${D}${libdir}/firmware/usrp_n300_fpga_HG.bin ${D}${libdir}/firmware/n300.bin
    mv ${D}${libdir}/firmware/usrp_n300_fpga_HG.dtbo ${D}${libdir}/firmware/n300.dtbo
    mv ${D}${libdir}/firmware/usrp_n310_fpga_HG.bin ${D}${libdir}/firmware/n310.bin
    mv ${D}${libdir}/firmware/usrp_n310_fpga_HG.dtbo ${D}${libdir}/firmware/n310.dtbo
    mv ${D}${libdir}/firmware/usrp_n320_fpga_HG.bin ${D}${libdir}/firmware/n320.bin
    mv ${D}${libdir}/firmware/usrp_n320_fpga_HG.dtbo ${D}${libdir}/firmware/n320.dtbo
}
