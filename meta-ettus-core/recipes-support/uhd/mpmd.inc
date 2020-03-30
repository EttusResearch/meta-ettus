require includes/maintainer-ettus.inc

SUMMARY = "Universal Hardware Driver for Ettus Research products (Hardware Daemon)."
HOMEPAGE = "http://www.ettus.com"
LICENSE = "GPLv3+"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS = " boost \
	    udev \
	    python3-setuptools-native \
	    python3-mako-native \
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
                  python3-mako \
                  udev \
                  dtc \
                  uhd-fpga-images-firmware \
                  iptables \
                  libgpiod-python \
                 "

RDEPENDS_${PN}-tests = " \
                  ${PN} \
                  python3-unittest-xml-reporting \
                  "

inherit distutils3-base cmake python3-dir python3native systemd
include uhd_auto_pkgv.inc

S = "${WORKDIR}/git/mpm"

MPM_DEVICE ?= "n3xx"
EXTRA_OECMAKE_append = " \
                  -DCMAKE_SKIP_RPATH=ON \
                  -DMPM_DEVICE=${MPM_DEVICE} \
                  -DGIT_EXECUTABLE=${HOSTTOOLS_DIR}/git \
                  "

SYSTEMD_PACKAGES = "${@bb.utils.contains('DISTRO_FEATURES','systemd','${PN}','',d)}"
SYSTEMD_SERVICE_${PN} = "${@bb.utils.contains('DISTRO_FEATURES','systemd','usrp-hwd.service','',d)}"

PACKAGES =+ "${PN}-tools ${PN}-tests"

FILES_${PN}     += "${systemd_unitdir}/network/*"
FILES_${PN}-dev += "${libdir}/libusrp-periphs.so"
FILES_${PN}-dbg += "${bindir}/mpm_debug.py"
FILES_${PN}-tools += "\
                     ${bindir}/eeprom-init \
                     ${bindir}/eeprom-blank \
                     ${bindir}/eeprom-dump \
                     ${bindir}/eeprom-set-flags \
                     "
FILES_${PN}-tests = "${libdir}/usrp_mpm/tests"

do_install_append() {
    mkdir -p ${D}${libdir}/usrp_mpm/tests/
    install -m 0644 ${S}/python/tests/*.py ${D}${libdir}/usrp_mpm/tests/

    if [ -d ${S}/python/tests/eeprom_tests ]; then
	    mkdir -p ${D}${libdir}/usrp_mpm/tests/eeprom_tests/
	    install -m 0644 ${S}/python/tests/eeprom_tests/*.eeprom ${D}${libdir}/usrp_mpm/tests/eeprom_tests/
    fi

    # prepend "40-" when installing .network files (e.g. eth0.network ->
    # 40-eth0.network) to make sure that the rules are applied before the
    # systemd default rules like 80-wired.network
    for FILENAME in ${D}${base_libdir}/systemd/network/*.network; do
        DIRNAME="$(dirname "$FILENAME")"
        BASENAME="$(basename "$FILENAME")"
        NEWNAME="40-$BASENAME"
        mv "$DIRNAME/$BASENAME" "$DIRNAME/$NEWNAME"
    done
}
