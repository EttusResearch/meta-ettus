FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " file://ec-sulfur-rev3.bin \
                             file://ec-sulfur-rev3.RW.bin \
                             file://ec-sulfur-rev5.bin \
                             file://ec-sulfur-rev5.RW.bin \
                             file://LICENSE.ec-sulfur \
                             file://fpga_bit_to_bin.py \
                             file://mykonos-m3.bin \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-76daf66/n3xx_n310_fpga_default.zip;name=sulfur-fpga \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-6bea23d/n3xx_n310_cpld_default.zip;name=magnesium-cpld \
                           "


SRC_URI[sulfur-fpga.md5sum] = "478a4883f3b97df3617ab0ef9ff5623d"
SRC_URI[sulfur-fpga.sha256sum] = "6d74d9846ec191bb28902be2a21358c6b3190b6b4dd94220e9d8e696fba60e9f"

SRC_URI[magnesium-cpld.md5sum] = "8971b73135bd91eee3ceba7ab7c856a5"
SRC_URI[magnesium-cpld.sha256sum] = "ef128dcd265ee8615b673021d4ee84c39357012ffe8b28c8ad7f893f9dcb94cb"

LICENSE += "& Firmware-ni-sulfur"
LIC_FILES_CHKSUM += "file://${WORKDIR}/LICENSE.ec-sulfur;md5=72f855f00b364ec8bdc025e1a36b39c3"

NO_GENERIC_LICENSE[Firmware-ni-sulfur] = "${WORKDIR}/LICENSE.ec-sulfur"
LICENSE_${PN}-ni-sulfur = "Firmware-ni-sulfur"

PACKAGES =+ " \
    ${PN}-ni-sulfur-license \
    ${PN}-ni-sulfur \
    ${PN}-ni-magnesium \
    ${PN}-ni-sulfur-fpga \
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
                         /lib/firmware/ni/ec-phosphorus-rev1.bin \
                         /lib/firmware/ni/ec-phosphorus-rev1.RW.bin \
                        "
RDEPENDS_${PN}-ni-sulfur += "${PN}-ni-sulfur-license"
DEPENDS += "dtc-native python-native"

# The CPLD image is GPL2 or X11 licensed
FILES_${PN}-ni-magnesium = " \
                           /lib/firmware/ni/cpld-magnesium-revc.svf \
                           "

LICENSE_${PN}-ni-magnesium = "Firmware-GPLv2"
RDEPENDS_${PN}-ni-magnesium += "${PN}-gplv2-license"

do_compile_append_ni-sulfur() {
    dtc -@ -o ${WORKDIR}/n3xx.dtbo ${WORKDIR}/usrp_n310_fpga_XG.dts
    python ${WORKDIR}/fpga_bit_to_bin.py -f ${WORKDIR}/usrp_n310_fpga_XG.bit ${WORKDIR}/n3xx.bin
}


do_install_append_ni-sulfur() {

    # For now they all run the same firmware, so symlinks will do ...
    install -D -m 0644 ${WORKDIR}/ec-sulfur-rev3.bin ${D}/lib/firmware/ni/ec-sulfur-rev3.bin
    install -m 0644 ${WORKDIR}/ec-sulfur-rev3.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev3.RW.bin

    install -D -m 0644 ${WORKDIR}/ec-sulfur-rev5.bin ${D}/lib/firmware/ni/ec-sulfur-rev5.bin
    install -m 0644 ${WORKDIR}/ec-sulfur-rev5.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev5.RW.bin

    ln -sf ec-sulfur-rev5.bin ${D}/lib/firmware/ni/ec-sulfur-rev4.bin
    ln -sf ec-sulfur-rev5.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev4.RW.bin

    ln -sf ec-sulfur-rev5.bin ${D}/lib/firmware/ni/ec-phosphorus-rev1.bin
    ln -sf ec-sulfur-rev5.RW.bin ${D}/lib/firmware/ni/ec-phosphorus-rev1.RW.bin

    install -m 0644 ${WORKDIR}/LICENSE.ec-sulfur ${D}/lib/firmware/ni/LICENSE.ec-sulfur

    install -m 0644 ${WORKDIR}/usrp_n310_mg_cpld.svf ${D}/lib/firmware/ni/cpld-magnesium-revc.svf
    install -D -m 0644 ${WORKDIR}/mykonos-m3.bin ${D}/lib/firmware/adi/mykonos-m3.bin

    install -m 0644 ${WORKDIR}/n3xx.bin ${D}/lib/firmware/n3xx.bin
    install -m 0644 ${WORKDIR}/n3xx.dtbo ${D}/lib/firmware/n3xx.dtbo
}

FILES_${PN}-adi-mykonos = " \
                           /lib/firmware/adi/mykonos-m3.bin \
                          "
LICENSE_${PN}-adi-mykonos = "CLOSED"

FILES_${PN}-ni-sulfur-fpga = " \
                              /lib/firmware/n3xx.bin \
                              /lib/firmware/n3xx.dtbo \
                             "

LICENSE_${PN}-ni-sulfur-fpga = "Firmware-GPLv2"
RDEPENDS_${PN}-ni-sulfur-fpga += "${PN}-gplv2-license"
