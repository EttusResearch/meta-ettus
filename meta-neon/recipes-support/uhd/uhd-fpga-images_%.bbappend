inherit uhd_images_downloader

FILES:${PN}:ni-neon = "${UHD_IMAGES_INSTALL_PATH}/usrp_e320_*.*"
FILES:${PN}-inventory:ni-neon = "${UHD_IMAGES_INSTALL_PATH}/inventory.json"
FILES:${PN}-firmware:ni-neon = " \
    ${libdir}/firmware/e320.bin \
    ${libdir}/firmware/e320.dtbo \
    "

UHD_IMAGES_TO_DOWNLOAD:ni-neon ?= " \
    e3xx_e320_fpga_default \
    "

UHD_FPGA_IMAGES_IN_FIRMWARE:ni-neon ?= " \
    usrp_e320_fpga_1G \
    "

do_install:append:ni-neon() {
    mkdir -p ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_e320_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}

    mv ${D}${libdir}/firmware/usrp_e320_fpga_1G.bin ${D}${libdir}/firmware/e320.bin
    mv ${D}${libdir}/firmware/usrp_e320_fpga_1G.dtbo ${D}${libdir}/firmware/e320.dtbo
}
