
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://ec-sulfur-rev3.bin \
                   file://ec-sulfur-rev3.RW.bin \
                   file://ec-sulfur-rev5.bin \
                   file://ec-sulfur-rev5.RW.bin \
                   file://LICENSE.ec-sulfur \
                   file://mykonos-m3.bin \
                   http://files.ettus.com/binaries/cache/n3xx/fpga-3de8954a/n3xx_n310_fpga_default-g3de8954a.zip;name=sulfur-fpga \
                   http://files.ettus.com/binaries/cache/n3xx/fpga-4bc2c6f/n3xx_n320_cpld_default-g4bc2c6f.zip;name=rhodium-cpld \
                   http://files.ettus.com/binaries/cache/n3xx/fpga-3de8954a/n3xx_n300_fpga_default-g3de8954a.zip;name=phosphorus-fpga \
                   http://files.ettus.com/binaries/cache/n3xx/fpga-3de8954a/n3xx_n320_fpga_default-g3de8954a.zip;name=rhodium-fpga \
                   http://files.ettus.com/binaries/cache/n3xx/fpga-6bea23d/n3xx_n310_cpld_default-g6bea23d.zip;name=magnesium-cpld \
                 "

SRC_URI[sulfur-fpga.sha256sum] = "0e3d07f2cc6f3a8d137f5e35b1a5888a7aebba90d4d13ca2516e0d9a1bc681d9"
SRC_URI[phosphorus-fpga.sha256sum] = "ee01ffa7d9ad40fd37373f94a608ddcd46f4f9ef50ad5c5778e125b18d0be04d"
SRC_URI[rhodium-fpga.sha256sum] = "b6a69c4ad4560955380f31e6ad99d0ff353dbc5f9241de5e4303a8fb21f5f4f7"
SRC_URI[magnesium-cpld.sha256sum] = "ef128dcd265ee8615b673021d4ee84c39357012ffe8b28c8ad7f893f9dcb94cb"
SRC_URI[rhodium-cpld.sha256sum] = "6680a9363efc5fa8b5a68beb3dff44f2e314b94e716e3a1751aba0fed1f384da"

LICENSE_append = "& Firmware-ni-sulfur"
LIC_FILES_CHKSUM_append = "file://${WORKDIR}/LICENSE.ec-sulfur;md5=72f855f00b364ec8bdc025e1a36b39c3"

NO_GENERIC_LICENSE[Firmware-ni-sulfur] = "${WORKDIR}/LICENSE.ec-sulfur"
LICENSE_${PN}-ni-sulfur = "Firmware-ni-sulfur"

PACKAGES =+ " \
    ${PN}-ni-sulfur-license \
    ${PN}-ni-sulfur \
    ${PN}-ni-magnesium \
    ${PN}-ni-rhodium \
    ${PN}-ni-sulfur-fpga \
    ${PN}-ni-phosphorus-fpga \
    ${PN}-adi-mykonos \
    ${PN}-ni-rhodium-fpga \
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

FILES_${PN}-ni-rhodium = " \
                           /lib/firmware/ni/cpld-rhodium-revb.svf \
                           "

LICENSE_${PN}-ni-rhodium = "Firmware-GPLv2"
RDEPENDS_${PN}-ni-rhodium += "${PN}-gplv2-license"


do_compile_append() {
    dtc -@ -o ${WORKDIR}/n310.dtbo ${WORKDIR}/usrp_n310_fpga_HG.dts
    python3 ${WORKDIR}/fpga_bit_to_bin.py -f ${WORKDIR}/usrp_n310_fpga_HG.bit ${WORKDIR}/n310.bin

    dtc -@ -o ${WORKDIR}/n300.dtbo ${WORKDIR}/usrp_n300_fpga_HG.dts
    python3 ${WORKDIR}/fpga_bit_to_bin.py -f ${WORKDIR}/usrp_n300_fpga_HG.bit ${WORKDIR}/n300.bin

    dtc -@ -o ${WORKDIR}/n320.dtbo ${WORKDIR}/usrp_n320_fpga_HG.dts
    python3 ${WORKDIR}/fpga_bit_to_bin.py -f ${WORKDIR}/usrp_n320_fpga_HG.bit ${WORKDIR}/n320.bin
}

do_install_append() {

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

    install -m 0644 ${WORKDIR}/usrp_n320_rh_cpld.svf ${D}/lib/firmware/ni/cpld-rhodium-revb.svf

    install -D -m 0644 ${WORKDIR}/mykonos-m3.bin ${D}/lib/firmware/adi/mykonos-m3.bin

    install -m 0644 ${WORKDIR}/n310.bin ${D}/lib/firmware/n310.bin
    install -m 0644 ${WORKDIR}/n310.dtbo ${D}/lib/firmware/n310.dtbo

    install -m 0644 ${WORKDIR}/n300.bin ${D}/lib/firmware/n300.bin
    install -m 0644 ${WORKDIR}/n300.dtbo ${D}/lib/firmware/n300.dtbo

    install -m 0644 ${WORKDIR}/n320.bin ${D}/lib/firmware/n320.bin
    install -m 0644 ${WORKDIR}/n320.dtbo ${D}/lib/firmware/n320.dtbo
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

FILES_${PN}-ni-rhodium-fpga = " \
                              /lib/firmware/n320.bin \
                              /lib/firmware/n320.dtbo \
                             "

LICENSE_${PN}-ni-rhodium-fpga = "Firmware-GPLv2"
RDEPENDS_${PN}-ni-rhodium-fpga += "${PN}-gplv2-license"

