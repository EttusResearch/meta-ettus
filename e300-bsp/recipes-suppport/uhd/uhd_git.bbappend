SRC_URI = "git://github.com/EttusResearch/uhd-e300-dev.git;branch=usrp3;protocol=https"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8255adf1069294c928e0e18b01a16282"

SRCREV = "be103fe4312622c5822272b209dedd396d9f8e57"

PV = "3.7.1+git${SRCPV}"

EXTRA_OECMAKE += " -DENABLE_E300=TRUE"

do_install_append() {
	install -d install -d ${D}${datadir}/uhd/images
	install -m 0644 ${S}/../binaries/usrp_e310_fpga.bit ${D}${datadir}/uhd/images
}
