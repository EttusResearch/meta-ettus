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
SRC_URI = "git://github.com/EttusResearch/liberio.git"
SRCREV = "81777e500d1c3b88d5048d46643fb5553eb5f786"
PR = "r1"

PACKAGES += "${PN}-examples"

FILES_${PN} = "${libdir}/lib*.so.* ${libdir}/lib*.la ${libdir}/liberio.pc"
FILES_${PN}-dev += "${includedir}/liberio/"
FILES_${PN}-examples = "${bindir}/*"
