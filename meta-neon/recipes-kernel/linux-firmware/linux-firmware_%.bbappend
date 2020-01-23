FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://ec-neon-rev1.RW.bin \
                   file://ec-neon-rev2.RW.bin \
                   file://ec-neon-rev3.RW.bin \
                   file://LICENSE.ec-neon \
                 "

LICENSE_append = "& Firmware-ni-neon"
LIC_FILES_CHKSUM_append = "file://${WORKDIR}/LICENSE.ec-neon;md5=72f855f00b364ec8bdc025e1a36b39c3"

NO_GENERIC_LICENSE[Firmware-ni-neon] = "${WORKDIR}/LICENSE.ec-neon"
LICENSE_${PN}-ni-neon = "Firmware-ni-neon"

PACKAGES_append_ni-neon = " \
    ${PN}-ni-neon-license \
    ${PN}-ni-neon \
    ${PN}-ni-neon-fpga \
    "

# The EC image is under the Chromium License, so add custom license file
FILES_${PN}-ni-neon-license = " \
                        /lib/firmware/ni/LICENSE.ec-neon \
                        "
FILES_${PN}-ni-neon = "/lib/firmware/ni/ec-neon-rev1.RW.bin \
                       /lib/firmware/ni/ec-neon-rev2.RW.bin \
                       /lib/firmware/ni/ec-neon-rev3.RW.bin \
                      "
RDEPENDS_${PN}-ni-neon += "${PN}-ni-neon-license"

# The FPGA images are provided by the uhd-fpga-images recipe
ALLOW_EMPTY_${PN}-ni-neon-fpga = "1"
RDEPENDS_${PN}-ni-neon-fpga = "uhd-fpga-images-e320-firmware"

do_install_append_ni-neon() {
    install -D -m 0644 ${WORKDIR}/ec-neon-rev1.RW.bin ${D}/lib/firmware/ni/ec-neon-rev1.RW.bin
    install -D -m 0644 ${WORKDIR}/ec-neon-rev2.RW.bin ${D}/lib/firmware/ni/ec-neon-rev2.RW.bin
    install -D -m 0644 ${WORKDIR}/ec-neon-rev3.RW.bin ${D}/lib/firmware/ni/ec-neon-rev3.RW.bin

    install -m 0644 ${WORKDIR}/LICENSE.ec-neon ${D}/lib/firmware/ni/LICENSE.ec-neon
}
