SRC_URI = "git://github.com/EttusResearch/uhd-e300-dev.git;branch=usrp3;protocol=https"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8255adf1069294c928e0e18b01a16282"

SRCREV = "a04c7f7b8a82a007f86415e2cddcd1085bb59bb8"

PV = "3.7.1+git${SRCPV}"

EXTRA_OECMAKE += " -DENABLE_E300=TRUE"

do_install_append() {
	install -d install -d ${D}${datadir}/uhd/images
	install -m 0644 ${S}/../binaries/usrp_e310_fpga.bit ${D}${datadir}/uhd/images
}
