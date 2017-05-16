FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur-rev3 = " file://ec-sulfur-rev3.bin \
                                  file://ec-sulfur-rev3.RW.bin \
				  file://LICENSE.ec-sulfur-rev3 \
"

LICENSE += "& Firmware-ni-sulfur-rev3"
LIC_FILES_CHKSUM += "file://${WORKDIR}/LICENSE.ec-sulfur-rev3;md5=72f855f00b364ec8bdc025e1a36b39c3"

NO_GENERIC_LICENSE[Firmware-ni-sulfur-rev3] = "${WORKDIR}/LICENSE.ec-sulfur-rev3"
LICENSE_${PN}-ni-sulfur-rev3 = "Firmware-ni-sulfur-rev3"

PACKAGES =+ "${PN}-ni-sulfur-rev3-license ${PN}-ni-sulfur-rev3"

FILES_${PN}-ni-sulfur-rev3-license = "/lib/firmware/ni/LICENSE.ec-sulfur-rev3"
FILES_${PN}-ni-sulfur-rev3 = "/lib/firmware/ni/ec-sulfur-rev3.bin \
                              /lib/firmware/ni/ec-sulfur-rev3.RW.bin \
			     "

RDEPENDS_${PN}-ni-sulfur-rev3 += "${PN}-ni-sulfur-rev3-license"

do_install_append_ni-sulfur-rev3() {
	install -D -m 0644 ${WORKDIR}/ec-sulfur-rev3.bin ${D}/lib/firmware/ni/ec-sulfur-rev3.bin
	install -m 0644 ${WORKDIR}/ec-sulfur-rev3.RW.bin ${D}/lib/firmware/ni/ec-sulfur-rev3.RW.bin
	install -m 0644 ${WORKDIR}/LICENSE.ec-sulfur-rev3 ${D}/lib/firmware/ni/LICENSE.ec-sulfur-rev3
}


