FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SUMMARY = "Free and Open On-Chip Debugging, In-System Programming and Boundary-Scan Testing"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"
DEPENDS = "libusb-compat libftdi"
RDEPENDS_${PN} = "libusb1"


SRC_URI = "git://repo.or.cz/openocd.git \
           file://sysfsgpio-ettus-magnesium-dba.cfg \
           file://sysfsgpio-ettus-magnesium-dbb.cfg \
	"
SRCREV = "f6449a7cba11de589c40169a7dd3b183bd60d1f4"

PR = "r2"
PV = "0.10+gitr${SRCPV}"
S = "${WORKDIR}/git"

inherit pkgconfig autotools-brokensep gettext

BBCLASSEXTEND += "nativesdk"

EXTRA_OECONF = "--enable-ftdi --disable-doxygen-html "

do_configure() {
    ./bootstrap
    oe_runconf ${EXTRA_OECONF}
}

do_install() {
    oe_runmake DESTDIR=${D} install
    if [ -e "${D}${infodir}" ]; then
      rm -Rf ${D}${infodir}
    fi

    install -D -m 0644 ${WORKDIR}/sysfsgpio-ettus-magnesium-dba.cfg ${D}${datadir}/openocd/scripts/interface
    install -D -m 0644 ${WORKDIR}/sysfsgpio-ettus-magnesium-dbb.cfg ${D}${datadir}/openocd/scripts/interface
}

FILES_${PN} = " \
  ${datadir}/openocd/* \
  ${bindir}/openocd \
  "
FILES_${PN}-dbg = " \
  ${bindir}/.debug \
  ${prefix}/src/debug \
"
FILES_${PN}-doc = " \
  ${infodir} \
  ${mandir} \
"

PACKAGECONFIG[sysfsgpio] = "--enable-sysfsgpio,--disable-sysfsgpio"
PACKAGECONFIG ??= "sysfsgpio"
