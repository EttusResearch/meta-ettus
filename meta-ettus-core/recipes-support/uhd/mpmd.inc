require includes/maintainer-ettus.inc

SUMMARY = "Universal Hardware Driver for Ettus Research products (Hardware Daemon)."
HOMEPAGE = "http://www.ettus.com"
LICENSE = "GPL-3.0-or-later"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DEPENDS = " boost \
	    udev \
	    pkgconfig-native \
	    python3-setuptools-native \
	    python3-mako-native \
	    protobuf-native \
	    grpc-native \
          "
RDEPENDS:${PN} = " \
                  dtc \
                  nftables \
                  python3-core \
                  python3-fcntl \
                  python3-gevent \
                  python3-gpiod \
                  python3-grpcio \
                  python3-mako \
                  python3-mmap \
                  python3-multiprocessing \
                  python3-netaddr \
                  python3-protobuf \
                  python3-pyroute2 \
                  python3-pyudev \
                  python3-requests \
                  python3-six \
                  python3-statistics \
                  python3-systemd \
                  udev \
                 "
RDEPENDS:${PN}:append:ni-e31x = " \
                  uhd-fpga-images-firmware \
                  usrp-firmware \
                 "
RDEPENDS:${PN}:append:ni-neon = " \
                  uhd-fpga-images-firmware \
                  usrp-firmware \
                 "
RDEPENDS:${PN}:append:ni-sulfur = " \
                  uhd-fpga-images-firmware \
                  usrp-firmware \
                 "
RDEPENDS:${PN}:append:ni-titanium = " \
                  uhd-fpga-images-firmware \
                  usrp-firmware \
                 "
RDEPENDS:${PN}-tools = " \
                  bash \
                 "

RDEPENDS:${PN}-tests = " \
                  ${PN} \
                  python3-unittest-xml-reporting \
                  "
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit setuptools3-base cmake python3-dir python3native systemd
include uhd_auto_pkgv.inc

S = "${WORKDIR}/git/mpm"

MPM_DEVICE ?= "sim"
MPM_DEVICE:ni-e31x = "e31x"
MPM_DEVICE:ni-neon = "e320"
MPM_DEVICE:ni-sulfur = "n3xx"
MPM_DEVICE:ni-titanium = "x4xx"

EXTRA_OECMAKE:append = " \
                  -DCMAKE_SKIP_RPATH=ON \
                  -DMPM_DEVICE=${MPM_DEVICE} \
                  -DGIT_EXECUTABLE=${HOSTTOOLS_DIR}/git \
                  -DPYTHON_EXECUTABLE=${PYTHON} \
                  -DRUNTIME_PYTHON_EXECUTABLE=/usr/bin/python3 \
                  "

SYSTEMD_SERVICE_MPMD = "${@bb.utils.contains('DISTRO_FEATURES','systemd','usrp-hwd.service','',d)}"

SYSTEMD_SERVICE:${PN}:ni-e31x = "${SYSTEMD_SERVICE_MPMD}"
SYSTEMD_SERVICE:${PN}:ni-neon = "${SYSTEMD_SERVICE_MPMD}"
SYSTEMD_SERVICE:${PN}:ni-sulfur = "${SYSTEMD_SERVICE_MPMD}"
SYSTEMD_SERVICE:${PN}:ni-titanium = "${SYSTEMD_SERVICE_MPMD}"

PACKAGES =+ "${PN}-tools ${PN}-tests"

FILES:${PN}     += " ${libdir}/sysctl.d/usrp-hwd.conf ${systemd_unitdir}/system/usrp-hwd.service ${systemd_unitdir}/network/*"
FILES:${PN}-dev += "${libdir}/libusrp-periphs.so"
FILES:${PN}-dbg += "${bindir}/mpm_debug.py"
FILES:${PN}-tools += " ${bindir}/eeprom-*"
FILES:${PN}-tests = "${libdir}/usrp_mpm/tests"

PACKAGE_DEBUG_SPLIT_STYLE = "debug-without-src"

do_install:append() {
    mkdir -p ${D}${libdir}/usrp_mpm/tests/
    install -m 0644 ${S}/python/tests/*.py ${D}${libdir}/usrp_mpm/tests/

    if [ -d ${S}/python/tests/eeprom_tests ]; then
	    mkdir -p ${D}${libdir}/usrp_mpm/tests/eeprom_tests/
	    install -m 0644 ${S}/python/tests/eeprom_tests/*.eeprom ${D}${libdir}/usrp_mpm/tests/eeprom_tests/
    fi

    # prepend "40-" when installing .network files (e.g. eth0.network ->
    # 40-eth0.network) to make sure that the rules are applied before the
    # systemd default rules like 80-wired.network
    if [ -d ${D}${base_libdir}/systemd/network ]; then
        for FILENAME in ${D}${base_libdir}/systemd/network/*.network; do
            DIRNAME="$(dirname "$FILENAME")"
            BASENAME="$(basename "$FILENAME")"
            NEWNAME="40-$BASENAME"
            mv "$DIRNAME/$BASENAME" "$DIRNAME/$NEWNAME"
        done
    fi
}

do_libusrp_periphs_sanity() {
    UNDEFINED=$(nm -D -u "${D}${libdir}/libusrp-periphs.so" | grep uhd) || true
    if [ -n "$UNDEFINED" ]; then
        bbfatal "undefined UHD symbols in libusrp-periphs.so: $UNDEFINED"
    fi
}
addtask do_libusrp_periphs_sanity after do_install before do_package
