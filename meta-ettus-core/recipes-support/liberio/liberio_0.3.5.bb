SUMMARY = "USRP DMA Engine interface library"
HOMEPAGE = "http://www.ettus.com/"
SECTION = "libs"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

inherit autotools pkgconfig

S = "${WORKDIR}/git"

RDEPENDS_liberio = "libudev"
DEPENDS = "udev"

SHRT_VER = "${@d.getVar('PV').split('.')[0]}.${@d.getVar('PV').split('.')[1]}"
SRC_URI = "git://github.com/EttusResearch/liberio.git;rev=b8736a87c6a70d33a70c5f938e2f81bd536317f8"

FILES_${PN} = "${libdir}/lib*.so.* ${libdir}/lib*.la ${libdir}/liberio.pc"
FILES_${PN}-dev += "${includedir}/liberio/"

do_install_append() {
	rm ${D}/${bindir} -r
}

