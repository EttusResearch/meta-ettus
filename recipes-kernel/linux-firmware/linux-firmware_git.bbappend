FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " file://ec-sulfur-rev3.bin \
                             file://ec-sulfur-rev3.RW.bin \
                             file://ec-sulfur-rev4.bin \
                             file://ec-sulfur-rev4.RW.bin \
                             file://LICENSE.ec-sulfur \
                             file://cpld-magnesium-revc.svf \
                           "

LICENSE += "& Firmware-ni-sulfur"
LIC_FILES_CHKSUM += "file://${WORKDIR}/LICENSE.ec-sulfur;md5=72f855f00b364ec8bdc025e1a36b39c3"

NO_GENERIC_LICENSE[Firmware-ni-sulfur] = "${WORKDIR}/LICENSE.ec-sulfur"
LICENSE_${PN}-ni-sulfur = "Firmware-ni-sulfur"

PACKAGES =+ " \
    ${PN}-ni-sulfur-license \
    ${PN}-ni-sulfur \
    ${PN}-ni-magnesium \
    "

# The EC image is under the Chromium License, so add custom license file
FILES_${PN}-ni-sulfur-license = " \
                        /lib/firmware/ni/LICENSE.ec-sulfur \
                        "
FILES_${PN}-ni-sulfur = "/lib/firmware/ni/ec-sulfur-rev3.bin \
                         /lib/firmware/ni/ec-sulfur-rev3.RW.bin \
                         /lib/firmware/ni/ec-sulfur-rev4.bin \
                         /lib/firmware/ni/ec-sulfur-rev4.RW.bin \
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
    install -m 0644 ${WORKDIR}/LICENSE.ec-sulfur ${D}/lib/firmware/ni/LICENSE.ec-sulfur

    install -m 0644 ${WORKDIR}/cpld-magnesium-revc.svf ${D}/lib/firmware/ni/cpld-magnesium-revc.svf
    install -m 0644 ${WORKDIR}/LICENSE.cpld-magnesium ${D}/lib/firmware/ni/LICENSE.cpld-magnesium
}
