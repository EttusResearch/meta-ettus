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
                  python3-six \
                  python3-pyroute2 \
                  udev \
                  dtc \
                 "

PR = "r14"
PV = "0.10"

include uhd-rev.inc

inherit distutils3-base cmake python3-dir python3native systemd

S = "${WORKDIR}/git/mpm"

MPM_DEVICE ?= "n3xx"
EXTRA_OECMAKE_append = " -DCMAKE_SKIP_RPATH=ON -DMPM_DEVICE=${MPM_DEVICE}"

SYSTEMD_PACKAGES = "${@bb.utils.contains('DISTRO_FEATURES','systemd','${PN}','',d)}"
SYSTEMD_SERVICE_${PN} = "${@bb.utils.contains('DISTRO_FEATURES','systemd','usrp-hwd.service','',d)}"

FILES_${PN}-dev += "${libdir}/libusrp-periphs.so"
FILES_${PN}-dbg += "${bindir}/mpm_debug.py"
