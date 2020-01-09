inherit uhd_images_downloader

EXTRA_PACKAGES_ni-sulfur ?= " \
    ${PN}-n300 \
    ${PN}-n310 \
    ${PN}-n320 \
    ${PN}-inventory \
"

PACKAGES_append_ni-sulfur = "${EXTRA_PACKAGES}"
PACKAGES_BEFORE_PN_append_ni-sulfur = "${EXTRA_PACKAGES}"
RDEPENDS_${PN}_ni-sulfur = "${EXTRA_PACKAGES}"

RPROVIDES_${PN}-n300 = "${PN}-phosphorus"
RPROVIDES_${PN}-n310 = "${PN}-sulfur"
RPROVIDES_${PN}-n320 = "${PN}-rhodium"

FILES_${PN}-n300 = "${UHD_IMAGES_INSTALL_PATH}/usrp_n300_*.*"
FILES_${PN}-n310 = "${UHD_IMAGES_INSTALL_PATH}/usrp_n310_*.*"
FILES_${PN}-n320 = "${UHD_IMAGES_INSTALL_PATH}/usrp_n320_*.*"
FILES_${PN}-inventory = "${UHD_IMAGES_INSTALL_PATH}/inventory.json"

UHD_IMAGES_TO_DOWNLOAD_ni-sulfur ?= " \
    n3xx_n300_fpga_default \
    n3xx_n310_fpga_default \
    n3xx_n320_fpga_default \
    "

do_install_append_ni-sulfur() {
    mkdir -p ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_n300_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_n310_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_n320_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}
}
