FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-neon = " file://ec-neon-rev1.RW.bin \
                           file://LICENSE.ec-neon \
                           http://files.ettus.com/binaries/cache/e3xx/fpga-abdc445a/e3xx_e320_fpga_default-gabdc445a.zip;name=neon-fpga \
                         "
SRC_URI[neon-fpga.md5sum] = "46ac1fe80d7c8e8cf242ef0189f6bcbe"
SRC_URI[neon-fpga.sha256sum] = "82e5af3742245f1f8ea5dd334b1ceb7920e3c31306d86b0dbf31bedd696879c4"

LICENSE += "& Firmware-ni-neon"
LIC_FILES_CHKSUM += "file://${WORKDIR}/LICENSE.ec-neon;md5=72f855f00b364ec8bdc025e1a36b39c3"

NO_GENERIC_LICENSE[Firmware-ni-neon] = "${WORKDIR}/LICENSE.ec-neon"
LICENSE_${PN}-ni-neon = "Firmware-ni-neon"

PACKAGES =+ " \
    ${PN}-ni-neon-license \
    ${PN}-ni-neon \
    ${PN}-ni-neon-fpga \
    "

# The EC image is under the Chromium License, so add custom license file
FILES_${PN}-ni-neon-license = " \
                        /lib/firmware/ni/LICENSE.ec-neon \
                        "
FILES_${PN}-ni-neon = "/lib/firmware/ni/ec-neon-rev1.RW.bin \
                      "
RDEPENDS_${PN}-ni-neon += "${PN}-ni-neon-license"
DEPENDS += "dtc-native python3-native"

NO_GENERIC_LICENSE[Firmware-ni-neon] = "${WORKDIR}/LICENSE.ec-neon"
LICENSE_${PN}-ni-neon = "Firmware-ni-neon"

do_compile_append_ni-neon() {
    dtc -@ -o ${WORKDIR}/e320.dtbo ${WORKDIR}/usrp_e320_fpga_1G.dts
    python3 ${WORKDIR}/fpga_bit_to_bin.py -f ${WORKDIR}/usrp_e320_fpga_1G.bit ${WORKDIR}/e320.bin
}

do_install_append_ni-neon() {

    install -D -m 0644 ${WORKDIR}/ec-neon-rev1.RW.bin ${D}/lib/firmware/ni/ec-neon-rev1.RW.bin

    install -m 0644 ${WORKDIR}/LICENSE.ec-neon ${D}/lib/firmware/ni/LICENSE.ec-neon

    install -m 0644 ${WORKDIR}/e320.bin ${D}/lib/firmware/e320.bin
    install -m 0644 ${WORKDIR}/e320.dtbo ${D}/lib/firmware/e320.dtbo
}

FILES_${PN}-ni-neon-fpga = " \
                              /lib/firmware/e320.bin \
                              /lib/firmware/e320.dtbo \
                             "

LICENSE_${PN}-ni-neon-fpga = "Firmware-GPLv2"
RDEPENDS_${PN}-ni-neon-fpga += "${PN}-gplv2-license"
