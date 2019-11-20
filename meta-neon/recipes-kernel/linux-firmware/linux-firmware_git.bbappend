FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://ec-neon-rev1.RW.bin \
                   file://ec-neon-rev2.RW.bin \
                   file://ec-neon-rev3.RW.bin \
                   file://LICENSE.ec-neon \
                   http://files.ettus.com/binaries/cache/e3xx/fpga-ce49fcb/e3xx_e320_fpga_default-gce49fcb.zip;name=neon-fpga;unpack=true \
                 "
SRC_URI[neon-fpga.sha256sum] = "084146049ac2824c5add7381e469df8d29a82632b1148ce746114ca3001f3706"

LICENSE_append = "& Firmware-ni-neon"
LIC_FILES_CHKSUM_append = "file://${WORKDIR}/LICENSE.ec-neon;md5=72f855f00b364ec8bdc025e1a36b39c3"

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
                       /lib/firmware/ni/ec-neon-rev2.RW.bin \
                       /lib/firmware/ni/ec-neon-rev3.RW.bin \
                      "
RDEPENDS_${PN}-ni-neon += "${PN}-ni-neon-license"
DEPENDS += "dtc-native python3-native"

do_compile_append() {
    dtc -@ -o ${WORKDIR}/e320.dtbo ${WORKDIR}/usrp_e320_fpga_1G.dts
    python3 ${WORKDIR}/fpga_bit_to_bin.py -f ${WORKDIR}/usrp_e320_fpga_1G.bit ${WORKDIR}/e320.bin
}

do_install_append() {
    install -D -m 0644 ${WORKDIR}/ec-neon-rev1.RW.bin ${D}/lib/firmware/ni/ec-neon-rev1.RW.bin
    install -D -m 0644 ${WORKDIR}/ec-neon-rev2.RW.bin ${D}/lib/firmware/ni/ec-neon-rev2.RW.bin
    install -D -m 0644 ${WORKDIR}/ec-neon-rev3.RW.bin ${D}/lib/firmware/ni/ec-neon-rev3.RW.bin

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
