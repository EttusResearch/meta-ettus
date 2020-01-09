inherit uhd_images_downloader

EXTRA_PACKAGES_ni-neon ?= " \
    ${PN}-e320 \
    ${PN}-inventory \
"

PACKAGES_append_ni-neon = "${EXTRA_PACKAGES}"
PACKAGES_BEFORE_PN_append_ni-neon = "${EXTRA_PACKAGES}"
RDEPENDS_${PN}_ni-neon += "${EXTRA_PACKAGES}"

RPROVIDES_${PN}-e320 = "${PN}-neon"

FILES_${PN}-e320 = "${UHD_IMAGES_INSTALL_PATH}/usrp_e320_*.*"
FILES_${PN}-inventory = "${UHD_IMAGES_INSTALL_PATH}/inventory.json"

UHD_IMAGES_TO_DOWNLOAD_ni-neon ?= " \
    e3xx_e320_fpga_default \
    "

do_install_append_ni-neon() {
    mkdir -p ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/usrp_e320_fpga*.* ${D}/${UHD_IMAGES_INSTALL_PATH}
    install -m 0644 ${S}/inventory.json    ${D}/${UHD_IMAGES_INSTALL_PATH}
}
