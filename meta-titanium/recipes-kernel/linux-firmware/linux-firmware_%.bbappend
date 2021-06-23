FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-titanium = " \
    file://LICENSE.ec-titanium \
    file://chromium-ec-ni-titanium-ec-rev4.bin \
    file://chromium-ec-ni-titanium-ec-rev4.RW.bin \
    "

LICENSE_append_ni-titanium = "& Firmware-ni-titanium"
LIC_FILES_CHKSUM_append_ni-titanium = "file://${WORKDIR}/LICENSE.ec-titanium;md5=72f855f00b364ec8bdc025e1a36b39c3"

NO_GENERIC_LICENSE[Firmware-ni-titanium] = "${WORKDIR}/LICENSE.ec-titanium"
LICENSE_${PN}-ni-titanium = "Firmware-ni-titanium"

PACKAGE_BEFORE_PN_append_ni-titanium = " \
    ${PN}-ni-titanium-license \
    ${PN}-ni-titanium \
    ${PN}-ni-titanium-fpga \
    "

# The EC image is under the Chromium License, so add custom license file
FILES_${PN}-ni-titanium-license = " \
                        /lib/firmware/ni/LICENSE.ec-titanium \
                        "
FILES_${PN}-ni-titanium = "/lib/firmware/ni/ec-titanium*.bin \
                          "
RDEPENDS_${PN}-ni-titanium += " \
                        ${PN}-ni-titanium-license \
                        ${PN}-ni-titanium-fpga \
                        "

# The FPGA images are provided by the uhd-fpga-images recipe
ALLOW_EMPTY_${PN}-ni-titanium-fpga = "1"
RDEPENDS_${PN}-ni-titanium-fpga = "uhd-fpga-images-titanium-firmware"

EC_MACHINE ??= "unknown"
EC_MACHINE_ni-titanium-rev5 = "ni-titanium-ec-rev5"
EC_MULTICONFIG ??= "ni-titanium-ec"

CROS_EC_DEPLOY_DIR_IMAGE ?= "${TOPDIR}/tmp-stm32-baremetal/deploy/images/${EC_MACHINE}"

do_install[mcdepends] = "multiconfig:ni-titanium:${EC_MULTICONFIG}:chromium-ec:do_deploy"

do_install_append_ni-titanium() {
    # install rev 4 firmware binaries
    install -D -m 0644 ${WORKDIR}/chromium-ec-ni-titanium-ec-rev4.bin ${D}/lib/firmware/ni/ec-titanium-rev4.bin
    install -D -m 0644 ${WORKDIR}/chromium-ec-ni-titanium-ec-rev4.RW.bin ${D}/lib/firmware/ni/ec-titanium-rev4.RW.bin

    # install embedded controller (ec) firmware
    install -D -m 0644 ${CROS_EC_DEPLOY_DIR_IMAGE}/ec-titanium-rev*.bin ${D}/lib/firmware/ni

    install -m 0644 ${WORKDIR}/LICENSE.ec-titanium ${D}/lib/firmware/ni/LICENSE.ec-titanium
}
