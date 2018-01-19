FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " file://ec-sulfur-rev3.bin \
                             file://ec-sulfur-rev3.RW.bin \
                             file://ec-sulfur-rev4.bin \
                             file://ec-sulfur-rev4.RW.bin \
                             file://ec-sulfur-rev5.bin \
                             file://ec-sulfur-rev5.RW.bin \
                             file://LICENSE.ec-sulfur \
                             file://mykonos-m3.bin \
                             http://orbitty.ni.corp.natinst.com:9090/sulfur-rev3-devel/n3xx-fpga-images/mvr/rc27/n3xx.bin;name=sulfur-fpga-image \
                             http://orbitty.ni.corp.natinst.com:9090/sulfur-rev3-devel/n3xx-fpga-images/mvr/rc27/n3xx.dtbo;name=sulfur-fpga-overlay \
                             http://orbitty.ni.corp.natinst.com:9090/sulfur-rev3-devel/n3xx-fpga-images/mvr/rc27/cpld-magnesium-revc.svf;name=magnesium-cpld-revc \
                           "

SRC_URI[sulfur-fpga-image.md5sum] = "80230d188c19f59e931436ad7975675a"
SRC_URI[sulfur-fpga-image.sha256sum] = "566ed9c32dcfa4f0a07a8a6ca934cda7ef3772101e36633da08b8e1452d2aab6"

SRC_URI[sulfur-fpga-overlay.md5sum] = "dfb07c6400b5d3a45c657947a4171c68"
SRC_URI[sulfur-fpga-overlay.sha256sum] = "fd526e6eddf4b822880db86e4a0ca7403ff2257ca8e68200d0cdcd9a4f539b8c"

SRC_URI[magnesium-cpld-revc.md5sum] = "2967d0c82b5f971fa20a928e368cbf13"
SRC_URI[magnesium-cpld-revc.sha256sum] = "b08271b275c7d6cec628c683bde4d9af12ba645539acc9810586dc3812b8a05a"

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
                        "
RDEPENDS_${PN}-ni-sulfur += "${PN}-ni-sulfur-license"

# The CPLD image is GPL2 or X11 licensed
FILES_${PN}-ni-magnesium = " \
                           /lib/firmware/ni/cpld-magnesium-revc.svf \
                           "

LICENSE_${PN}-ni-magnesium = "Firmware-GPLv2"
RDEPENDS_${PN}-ni-magnesium += "${PN}-gplv2-license"

do_install_append_ni-sulfur() {
    install -D -m 0644 ${WORKDIR}/ec-sulfur-rev3.bin ${D}/lib/firmware/ni/ec-sulfur-rev3.bin
    install -m 0644 ${WORKDIR}/ec-sulfur-rev3.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev3.RW.bin
    install -D -m 0644 ${WORKDIR}/ec-sulfur-rev4.bin ${D}/lib/firmware/ni/ec-sulfur-rev4.bin
    install -m 0644 ${WORKDIR}/ec-sulfur-rev4.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev4.RW.bin
    install -D -m 0644 ${WORKDIR}/ec-sulfur-rev5.bin ${D}/lib/firmware/ni/ec-sulfur-rev5.bin
    install -m 0644 ${WORKDIR}/ec-sulfur-rev5.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev5.RW.bin

    install -m 0644 ${WORKDIR}/LICENSE.ec-sulfur ${D}/lib/firmware/ni/LICENSE.ec-sulfur

    install -m 0644 ${WORKDIR}/cpld-magnesium-revc.svf ${D}/lib/firmware/ni/cpld-magnesium-revc.svf
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
