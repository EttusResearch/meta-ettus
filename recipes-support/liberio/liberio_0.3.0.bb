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
SRC_URI = "git://orbitty.ni.corp.natinst.com/vb2-test.git;rev=99cb1d5f7a5960a3ed4033374e32582bf16a965b"

FILES_${PN} = "${libdir}/lib*.so.* ${libdir}/lib*.la ${libdir}/liberio.pc"
FILES_${PN}-dev += "${includedir}/liberio/"

do_install_append() {
	rm ${D}/${bindir} -r
}

