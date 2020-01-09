inherit uhd_images_downloader

EXTRA_PACKAGES_ni-e31x-sg1 ?= " \
    ${PN}-e310-sg1 \
    ${PN}-inventory \
"

EXTRA_PACKAGES_ni-e31x-sg3 ?= " \
    ${PN}-e310-sg3 \
    ${PN}-inventory \
"

PACKAGES_append_ni-e31x = "${EXTRA_PACKAGES}"
PACKAGES_BEFORE_PN_append_ni-e31x = "${EXTRA_PACKAGES}"
RDEPENDS_${PN}_ni-e31x += "${EXTRA_PACKAGES}"

FILES_${PN}-e310-sg1 = "${UHD_IMAGES_INSTALL_PATH}/usrp_e310_sg1_*.*"
FILES_${PN}-e310-sg3 = "${UHD_IMAGES_INSTALL_PATH}/usrp_e310_sg3_*.*"
FILES_${PN}-inventory = "${UHD_IMAGES_INSTALL_PATH}/inventory.json"

UHD_IMAGES_TO_DOWNLOAD_ni-e31x-sg1 ?= " \
    e3xx_e310_sg1_fpga_default \
    "

UHD_IMAGES_TO_DOWNLOAD_ni-e31x-sg3 ?= " \
    e3xx_e310_sg3_fpga_default \
    "

do_install_append_ni-e31x-sg1() {
    mkdir -p ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_e310_sg1_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}
}

do_install_append_ni-e31x-sg3() {
    mkdir -p ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_e310_sg3_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}
}
