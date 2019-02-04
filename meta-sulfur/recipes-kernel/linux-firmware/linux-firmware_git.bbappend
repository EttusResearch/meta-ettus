
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " file://ec-sulfur-rev3.bin \
                             file://ec-sulfur-rev3.RW.bin \
                             file://ec-sulfur-rev5.bin \
                             file://ec-sulfur-rev5.RW.bin \
                             file://LICENSE.ec-sulfur \
                             file://mykonos-m3.bin \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-1107862/n3xx_n310_fpga_default-g1107862.zip;name=sulfur-fpga \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-1107862/n3xx_n300_fpga_default-g1107862.zip;name=phosphorus-fpga \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-6bea23d/n3xx_n310_cpld_default.zip;name=magnesium-cpld \
                           "


SRC_URI[sulfur-fpga.md5sum] = "51a9fcf2161dfd12682c17d7bd467af3"
SRC_URI[sulfur-fpga.sha256sum] = "fc80462f2e144d9745b0b480aa513f426e48df46ad18dc85cbb8fdb3cb162355"

SRC_URI[phosphorus-fpga.md5sum] = "a356a95877bbc826deefacf62549bfff"
SRC_URI[phosphorus-fpga.sha256sum] = "1e7ae1429825811531149f87f82dfcbc06cf63e1fc3752517edf104950406c36"

SRC_URI[magnesium-cpld.md5sum] = "8971b73135bd91eee3ceba7ab7c856a5"
SRC_URI[magnesium-cpld.sha256sum] = "ef128dcd265ee8615b673021d4ee84c39357012ffe8b28c8ad7f893f9dcb94cb"

LICENSE_append_ni-sulfur = "& Firmware-ni-sulfur"
LIC_FILES_CHKSUM_append_ni-sulfur = "file://${WORKDIR}/LICENSE.ec-sulfur;md5=72f855f00b364ec8bdc025e1a36b39c3"

NO_GENERIC_LICENSE[Firmware-ni-sulfur] = "${WORKDIR}/LICENSE.ec-sulfur"
LICENSE_${PN}-ni-sulfur = "Firmware-ni-sulfur"

PACKAGES =+ " \
    ${PN}-ni-sulfur-license \
    ${PN}-ni-sulfur \
    ${PN}-ni-magnesium \
    ${PN}-ni-sulfur-fpga \
    ${PN}-ni-phosphorus-fpga \
    ${PN}-adi-mykonos \
    "

# The EC image is under the Chromium License, so add custom license file
FILES_${PN}-ni-sulfur-license = " \
                        /lib/firmware/ni/LICENSE.ec-sulfur \
                        "
FILES_${PN}-ni-sulfur = "/lib/firmware/ni/ec-sulfur-rev3.bin \
                         /lib/firmware/ni/ec-sulfur-rev3.RW.bin \
                         /lib/firmware/ni/ec-sulfur-rev4.bin \
                         /lib/firmware/ni/ec-sulfur-rev4.RW.bin \
                         /lib/firmware/ni/ec-sulfur-rev5.bin \
                         /lib/firmware/ni/ec-sulfur-rev5.RW.bin \
                         /lib/firmware/ni/ec-sulfur-rev6.bin \
                         /lib/firmware/ni/ec-sulfur-rev6.RW.bin \
                         /lib/firmware/ni/ec-phosphorus-rev4.bin \
                         /lib/firmware/ni/ec-phosphorus-rev4.RW.bin \
                         /lib/firmware/ni/ec-phosphorus-rev6.bin \
                         /lib/firmware/ni/ec-phosphorus-rev6.RW.bin \
                        "
RDEPENDS_${PN}-ni-sulfur += "${PN}-ni-sulfur-license"
DEPENDS += "dtc-native python3-native"

# The CPLD image is GPL2 or X11 licensed
FILES_${PN}-ni-magnesium = " \
                           /lib/firmware/ni/cpld-magnesium-revc.svf \
                           "

LICENSE_${PN}-ni-magnesium = "Firmware-GPLv2"
RDEPENDS_${PN}-ni-magnesium += "${PN}-gplv2-license"

do_compile_append_ni-sulfur() {
    dtc -@ -o ${WORKDIR}/n310.dtbo ${WORKDIR}/usrp_n310_fpga_HG.dts
    python3 ${WORKDIR}/fpga_bit_to_bin.py -f ${WORKDIR}/usrp_n310_fpga_HG.bit ${WORKDIR}/n310.bin

    dtc -@ -o ${WORKDIR}/n300.dtbo ${WORKDIR}/usrp_n300_fpga_HG.dts
    python3 ${WORKDIR}/fpga_bit_to_bin.py -f ${WORKDIR}/usrp_n300_fpga_HG.bit ${WORKDIR}/n300.bin
}

do_install_append_ni-sulfur() {

    # For now they all run the same firmware, so symlinks will do ...
    install -D -m 0644 ${WORKDIR}/ec-sulfur-rev3.bin ${D}/lib/firmware/ni/ec-sulfur-rev3.bin
    install -m 0644 ${WORKDIR}/ec-sulfur-rev3.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev3.RW.bin

    # Rev5+ firmware now differs from rev3 firmware, since it adds more margin in bootdelay
    install -D -m 0644 ${WORKDIR}/ec-sulfur-rev5.bin ${D}/lib/firmware/ni/ec-sulfur-rev5.bin
    install -m 0644 ${WORKDIR}/ec-sulfur-rev5.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev5.RW.bin

    ln -sf ec-sulfur-rev5.bin ${D}/lib/firmware/ni/ec-sulfur-rev4.bin
    ln -sf ec-sulfur-rev5.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev4.RW.bin

    ln -sf ec-sulfur-rev5.bin ${D}/lib/firmware/ni/ec-sulfur-rev6.bin
    ln -sf ec-sulfur-rev5.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev6.RW.bin

    ln -sf ec-sulfur-rev5.bin ${D}/lib/firmware/ni/ec-phosphorus-rev4.bin
    ln -sf ec-sulfur-rev5.RW.bin ${D}/lib/firmware/ni/ec-phosphorus-rev4.RW.bin

    ln -sf ec-sulfur-rev5.bin ${D}/lib/firmware/ni/ec-phosphorus-rev6.bin
    ln -sf ec-sulfur-rev5.RW.bin ${D}/lib/firmware/ni/ec-phosphorus-rev6.RW.bin

    install -m 0644 ${WORKDIR}/LICENSE.ec-sulfur ${D}/lib/firmware/ni/LICENSE.ec-sulfur

    install -m 0644 ${WORKDIR}/usrp_n310_mg_cpld.svf ${D}/lib/firmware/ni/cpld-magnesium-revc.svf
    # This workaround ultimately should go away once the .svf is generated correctly
    sed -i -e 's/FREQUENCY 1.80E+07/FREQUENCY 1.00E+07/g' ${D}/lib/firmware/ni/cpld-magnesium-revc.svf

    install -D -m 0644 ${WORKDIR}/mykonos-m3.bin ${D}/lib/firmware/adi/mykonos-m3.bin

    install -m 0644 ${WORKDIR}/n310.bin ${D}/lib/firmware/n310.bin
    install -m 0644 ${WORKDIR}/n310.dtbo ${D}/lib/firmware/n310.dtbo

    install -m 0644 ${WORKDIR}/n300.bin ${D}/lib/firmware/n300.bin
    install -m 0644 ${WORKDIR}/n300.dtbo ${D}/lib/firmware/n300.dtbo
}

FILES_${PN}-adi-mykonos = " \
                           /lib/firmware/adi/mykonos-m3.bin \
                          "
LICENSE_${PN}-adi-mykonos = "CLOSED"

FILES_${PN}-ni-sulfur-fpga = " \
                              /lib/firmware/n310.bin \
                              /lib/firmware/n310.dtbo \
                             "

LICENSE_${PN}-ni-sulfur-fpga = "Firmware-GPLv2"
RDEPENDS_${PN}-ni-sulfur-fpga += "${PN}-gplv2-license"

FILES_${PN}-ni-phosphorus-fpga = " \
                              /lib/firmware/n300.bin \
                              /lib/firmware/n300.dtbo \
                             "

LICENSE_${PN}-ni-phosphorus-fpga = "Firmware-GPLv2"
RDEPENDS_${PN}-ni-phosphorus-fpga += "${PN}-gplv2-license"
