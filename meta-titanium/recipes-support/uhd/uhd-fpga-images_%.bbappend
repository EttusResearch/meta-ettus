inherit uhd_images_downloader

# FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# SRC_URI:append:ni-titanium = " \
#     file://set-symlinks.py \
#     "

FILES:${PN}:ni-titanium = " \
    ${UHD_IMAGES_INSTALL_PATH}/usrp_x410_fpga*.* \
    ${UHD_IMAGES_INSTALL_PATH}/usrp_x440_fpga*.* \
    "
FILES:${PN}-inventory:ni-titanium = "${UHD_IMAGES_INSTALL_PATH}/inventory.json"
FILES:${PN}-firmware:ni-titanium = " \
    ${libdir}/firmware/x410.bin \
    ${libdir}/firmware/x410.dtbo \
    ${libdir}/firmware/x440.bin \
    ${libdir}/firmware/x440.dtbo \
    "

UHD_IMAGES_TO_DOWNLOAD:ni-titanium ?= " \
    x4xx_x410_fpga_default \
    x4xx_x440_fpga_default \
    "

DEFAULT_BITFILE_NAME_X410 = "usrp_x410_fpga_X4_200"
DEFAULT_BITFILE_NAME_X440 = "usrp_x440_fpga_X4_400"

UHD_FPGA_IMAGES_IN_FIRMWARE:ni-titanium ?= " \
    ${DEFAULT_BITFILE_NAME_X410} \
    ${DEFAULT_BITFILE_NAME_X440} \
    "

# FPGA_SUBDIRECTORY ??= ""

# do_download_uhd_images:append:ni-titanium() {
#     if [ -n "${EXTERNALSRC}" ]; then
#         ln -sf "${S}/${FPGA_SUBDIRECTORY}/${DEFAULT_BITFILE_NAME_X410}.bit" "${UHD_IMAGES_DOWNLOAD_DIR}/${DEFAULT_BITFILE_NAME_X410}.bit"
#         ln -sf "${S}/${FPGA_SUBDIRECTORY}/${DEFAULT_BITFILE_NAME_X410}.dts" "${UHD_IMAGES_DOWNLOAD_DIR}/${DEFAULT_BITFILE_NAME_X410}.dts"
#         ln -sf "${S}/${FPGA_SUBDIRECTORY}/${DEFAULT_BITFILE_NAME_X440}.bit" "${UHD_IMAGES_DOWNLOAD_DIR}/${DEFAULT_BITFILE_NAME_X440}.bit"
#         ln -sf "${S}/${FPGA_SUBDIRECTORY}/${DEFAULT_BITFILE_NAME_X440}.dts" "${UHD_IMAGES_DOWNLOAD_DIR}/${DEFAULT_BITFILE_NAME_X440}.dts"
#     else
#         python3 ${WORKDIR}/set-symlinks.py -i ${UHD_IMAGES_DOWNLOAD_DIR} -d ${UHD_IMAGES_DOWNLOAD_DIR}
#     fi
# }

do_install:append:ni-titanium() {
    install -d ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${UHD_IMAGES_DOWNLOAD_DIR}/usrp_x410_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${UHD_IMAGES_DOWNLOAD_DIR}/usrp_x440_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${UHD_IMAGES_DOWNLOAD_DIR}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}

    mv ${D}${libdir}/firmware/${DEFAULT_BITFILE_NAME_X410}.bin ${D}${libdir}/firmware/x410.bin
    mv ${D}${libdir}/firmware/${DEFAULT_BITFILE_NAME_X410}.dtbo ${D}${libdir}/firmware/x410.dtbo
    mv ${D}${libdir}/firmware/${DEFAULT_BITFILE_NAME_X440}.bin ${D}${libdir}/firmware/x440.bin
    mv ${D}${libdir}/firmware/${DEFAULT_BITFILE_NAME_X440}.dtbo ${D}${libdir}/firmware/x440.dtbo
}
