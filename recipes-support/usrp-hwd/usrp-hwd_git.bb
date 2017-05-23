SUMMARY = "Universal Hardware Driver for Ettus Research products (Hardware Daemon)."
HOMEPAGE = "http://www.ettus.com"
LICENSE = "GPLv3+"
LIC_FILES_CHKSUM = "file://../host/LICENSE;md5=8255adf1069294c928e0e18b01a16282"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS = " boost python-netaddr \
	    udev \
	    python-setuptools-native \
            python-pyroute2 \
          "

PR = "r2"
PV = "0.1+gitr${SRCPV}"

SRCREV = "44365fcccc95ba9117e8043aa87c94226b07fde4"

SRC_URI = "git://git@github.com/EttusResearch/uhddev.git;protocol=ssh;branch=n3xx-master \
           file://usrp-hwd.service \
          "

inherit distutils-base cmake python-dir pythonnative systemd

S = "${WORKDIR}/git/mpm"

EXTRA_OECMAKE_append = " -DCMAKE_SKIP_RPATH=ON"

RDEPENDS_${PN} += "python-six python-netaddr python-mprpc udev"

SYSTEMD_PACKAGES = "${@bb.utils.contains('DISTRO_FEATURES','systemd','${PN}','',d)}"
SYSTEMD_SERVICE_${PN} = "${@bb.utils.contains('DISTRO_FEATURES','systemd','usrp-hwd.service','',d)}"

do_install_append() {
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
		install -d ${D}${systemd_unitdir}/system
		install -m 644 ${WORKDIR}/*.service ${D}/${systemd_unitdir}/system
	fi
}

FILES_${PN}-dev += "${libdir}/libusrp-periphs.so"
FILES_${PN}-dbg += "${bindir}/mpm_debug.py"
