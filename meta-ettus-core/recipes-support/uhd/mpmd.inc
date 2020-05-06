require includes/maintainer-ettus.inc

SUMMARY = "Universal Hardware Driver for Ettus Research products (Hardware Daemon)."
HOMEPAGE = "http://www.ettus.com"
LICENSE = "GPLv3+"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS = " boost \
	    udev \
	    python3-setuptools-native \
          "
RDEPENDS_${PN} = " \
                  python3-core \
                  python3-netaddr \
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
                  uhd-fpga-images-firmware \
                  iptables \
                 "

inherit distutils3-base cmake python3-dir python3native systemd

S = "${WORKDIR}/git/mpm"

MPM_DEVICE ?= "n3xx"
EXTRA_OECMAKE_append = " -DCMAKE_SKIP_RPATH=ON -DMPM_DEVICE=${MPM_DEVICE}"

SYSTEMD_PACKAGES = "${@bb.utils.contains('DISTRO_FEATURES','systemd','${PN}','',d)}"
SYSTEMD_SERVICE_${PN} = "${@bb.utils.contains('DISTRO_FEATURES','systemd','usrp-hwd.service','',d)}"

PACKAGES =+ "${PN}-tools"

FILES_${PN}-dev += "${libdir}/libusrp-periphs.so"
FILES_${PN}-dbg += "${bindir}/mpm_debug.py"
FILES_${PN}-tools += "\
                     ${bindir}/eeprom-init \
                     ${bindir}/eeprom-blank \
                     ${bindir}/eeprom-dump \
                     ${bindir}/eeprom-set-flags \
                     "
