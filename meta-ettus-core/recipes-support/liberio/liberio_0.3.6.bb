SUMMARY = "USRP DMA Engine interface library"
HOMEPAGE = "http://www.ettus.com/"
SECTION = "libs"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

inherit autotools pkgconfig
require includes/maintainer-ettus.inc

S = "${WORKDIR}/git"

RDEPENDS_liberio = "libudev"
DEPENDS = "udev"

SHRT_VER = "${@d.getVar('PV').split('.')[0]}.${@d.getVar('PV').split('.')[1]}"
SRC_URI = "git://github.com/EttusResearch/liberio.git;rev=d1c8ade285117f38d2d0b8a406e3641622fe3351"

FILES_${PN} = "${libdir}/lib*.so.* ${libdir}/lib*.la ${libdir}/liberio.pc"
FILES_${PN}-dev += "${includedir}/liberio/"

do_install_append() {
	rm ${D}/${bindir} -r
}
