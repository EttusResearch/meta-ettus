inherit uhd_images_downloader

# FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# SRC_URI:append:ni-titanium = " \
#     file://set-symlinks.py \
#     "

FILES:${PN}:ni-titanium = " \
    ${UHD_IMAGES_INSTALL_PATH}/usrp_x410_fpga*.* \
    ${UHD_IMAGES_INSTALL_PATH}/usrp_x420_fpga*.* \
    ${UHD_IMAGES_INSTALL_PATH}/usrp_x440_fpga*.* \
    "
FILES:${PN}-inventory:ni-titanium = "${UHD_IMAGES_INSTALL_PATH}/inventory.json"
FILES:${PN}-firmware:ni-titanium = " \
    ${libdir}/firmware/x410.bin \
    ${libdir}/firmware/x410.dtbo \
    ${libdir}/firmware/x420.bin \
    ${libdir}/firmware/x420.dtbo \
    ${libdir}/firmware/x440.bin \
    ${libdir}/firmware/x440.dtbo \
    "

UHD_IMAGES_TO_DOWNLOAD:ni-titanium ?= " \
    x4xx_x410_fpga_default \
    x4xx_x420_fpga_default \
    x4xx_x440_fpga_default \
    "

DEFAULT_BITFILE_NAME_X410 = "usrp_x410_fpga_X4_200"
DEFAULT_BITFILE_NAME_X420 = "usrp_x420_fpga_X4_1000"
DEFAULT_BITFILE_NAME_X440 = "usrp_x440_fpga_X4_400"

UHD_FPGA_IMAGES_IN_FIRMWARE:ni-titanium ?= " \
    ${DEFAULT_BITFILE_NAME_X410} \
    ${DEFAULT_BITFILE_NAME_X420} \
    ${DEFAULT_BITFILE_NAME_X440} \
    "

do_install:append:ni-titanium() {
    install -d ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${UHD_IMAGES_DOWNLOAD_DIR}/usrp_x410_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${UHD_IMAGES_DOWNLOAD_DIR}/usrp_x420_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${UHD_IMAGES_DOWNLOAD_DIR}/usrp_x440_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${UHD_IMAGES_DOWNLOAD_DIR}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}

    mv ${D}${libdir}/firmware/${DEFAULT_BITFILE_NAME_X410}.bin ${D}${libdir}/firmware/x410.bin
    mv ${D}${libdir}/firmware/${DEFAULT_BITFILE_NAME_X410}.dtbo ${D}${libdir}/firmware/x410.dtbo
    mv ${D}${libdir}/firmware/${DEFAULT_BITFILE_NAME_X420}.bin ${D}${libdir}/firmware/x420.bin
    mv ${D}${libdir}/firmware/${DEFAULT_BITFILE_NAME_X420}.dtbo ${D}${libdir}/firmware/x420.dtbo
    mv ${D}${libdir}/firmware/${DEFAULT_BITFILE_NAME_X440}.bin ${D}${libdir}/firmware/x440.bin
    mv ${D}${libdir}/firmware/${DEFAULT_BITFILE_NAME_X440}.dtbo ${D}${libdir}/firmware/x440.dtbo
}
