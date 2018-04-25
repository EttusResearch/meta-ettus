SUMMARY = "Universal Hardware Driver for Ettus Research products (Hardware Daemon)."
HOMEPAGE = "http://www.ettus.com"
LICENSE = "GPLv3+"
LIC_FILES_CHKSUM = "file://../host/LICENSE;md5=8255adf1069294c928e0e18b01a16282"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS = " boost \
	    udev \
	    python3-setuptools-native \
          "
RDEPENDS_${PN} = "python3-netaddr \
                  python3-pyudev \
                  python3-gevent \
                  python3-systemd \
                  python3-requests \
                  python3-mprpc \
                  python3-multiprocessing \
                  python3-mmap \
                  python3-fcntl \
                  python3-six \
                  python3-pyroute2 \
                  udev \
                  dtc \
                 "

PR = "r0"
PV = "3.11.0.1"

SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=master \
          "
SRCREV = "77b87095da830558d26d0832fc08b3320f564f12"

inherit distutils3-base cmake python3-dir python3native systemd

S = "${WORKDIR}/git/mpm"

EXTRA_OECMAKE_append = " -DCMAKE_SKIP_RPATH=ON -DMPM_PYTHON_VER=3"

SYSTEMD_PACKAGES = "${@bb.utils.contains('DISTRO_FEATURES','systemd','${PN}','',d)}"
SYSTEMD_SERVICE_${PN} = "${@bb.utils.contains('DISTRO_FEATURES','systemd','usrp-hwd.service','',d)}"

FILES_${PN}-dev += "${libdir}/libusrp-periphs.so"
FILES_${PN}-dbg += "${bindir}/mpm_debug.py"
