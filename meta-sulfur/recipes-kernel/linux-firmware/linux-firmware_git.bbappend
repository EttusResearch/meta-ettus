
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://ec-sulfur-rev3.bin \
                   file://ec-sulfur-rev3.RW.bin \
                   file://ec-sulfur-rev5.bin \
                   file://ec-sulfur-rev5.RW.bin \
                   file://ec-sulfur-rev10.bin \
                   file://ec-sulfur-rev10.RW.bin \
                   file://LICENSE.ec-sulfur \
                   file://mykonos-m3.bin \
                   http://files.ettus.com/binaries/cache/n3xx/fpga-9e3d00c/n3xx_n310_fpga_default-g9e3d00c.zip;name=sulfur-fpga;unpack=true \
                   http://files.ettus.com/binaries/cache/n3xx/fpga-4bc2c6f/n3xx_n320_cpld_default-g4bc2c6f.zip;name=rhodium-cpld;unpack=true \
                   http://files.ettus.com/binaries/cache/n3xx/fpga-9e3d00c/n3xx_n300_fpga_default-g9e3d00c.zip;name=phosphorus-fpga;unpack=true \
                   http://files.ettus.com/binaries/cache/n3xx/fpga-9e3d00c/n3xx_n320_fpga_default-g9e3d00c.zip;name=rhodium-fpga;unpack=true \
                   http://files.ettus.com/binaries/cache/n3xx/fpga-6bea23d/n3xx_n310_cpld_default-g6bea23d.zip;name=magnesium-cpld;unpack=true \
                 "

SRC_URI[sulfur-fpga.sha256sum] = "b6ba63f0b36081526aec085708676d727039ee8fb639cd0a944ba4ac719c3640"
SRC_URI[phosphorus-fpga.sha256sum] = "fb6af0d9d4744a1354b7f42fc8583b37964b36ef8ea4cddc073eac68fc0533bc"
SRC_URI[rhodium-fpga.sha256sum] = "40dfb873a294cd574d5ca24de6d1908bb6257bc0db5204c70de90589227915c6"
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
FILES_${PN}-ni-sulfur = "/lib/firmware/ni/ec-sulfur*.bin \
                         /lib/firmware/ni/ec-phosphorus*.bin \
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

    # legacy rev. 3 firmware
    install -D -m 0644 ${WORKDIR}/ec-sulfur-rev3.bin ${D}/lib/firmware/ni/ec-sulfur-rev3.bin
    install -m 0644 ${WORKDIR}/ec-sulfur-rev3.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev3.RW.bin

    # Rev5+ firmware now differs from rev3 firmware, since it adds more margin in bootdelay
    install -D -m 0644 ${WORKDIR}/ec-sulfur-rev5.bin ${D}/lib/firmware/ni/ec-sulfur-rev5.bin
    install -m 0644 ${WORKDIR}/ec-sulfur-rev5.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev5.RW.bin

    for REV in 4 6 7 8 9
    do
      ln -sf ec-sulfur-rev5.bin ${D}/lib/firmware/ni/ec-sulfur-rev${REV}.bin
      ln -sf ec-sulfur-rev5.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev${REV}.RW.bin
    done

    for REV in 4 5 6 7 8 9
    do
      ln -sf ec-sulfur-rev5.bin ${D}/lib/firmware/ni/ec-phosphorus-rev${REV}.bin
      ln -sf ec-sulfur-rev5.RW.bin ${D}/lib/firmware/ni/ec-phosphorus-rev${REV}.RW.bin
    done

    # Rev 10+ firmware uses GPIOs which can en-/disable the 12V of the daughter cards and the fans
    install -D -m 0644 ${WORKDIR}/ec-sulfur-rev10.bin ${D}/lib/firmware/ni/ec-sulfur-rev10.bin
    install -m 0644 ${WORKDIR}/ec-sulfur-rev10.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev10.RW.bin

    for REV in 11
    do
      ln -sf ec-sulfur-rev10.bin ${D}/lib/firmware/ni/ec-sulfur-rev${REV}.bin
      ln -sf ec-sulfur-rev10.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev${REV}.RW.bin
    done

    for REV in 10 11
    do
      ln -sf ec-sulfur-rev10.bin ${D}/lib/firmware/ni/ec-phosphorus-rev${REV}.bin
      ln -sf ec-sulfur-rev10.RW.bin ${D}/lib/firmware/ni/ec-phosphorus-rev${REV}.RW.bin
    done

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
