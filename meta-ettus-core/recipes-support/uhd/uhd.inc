SUMMARY = "Universal Hardware Driver for Ettus Research products."
HOMEPAGE = "http://www.ettus.com"
LICENSE = "GPLv3+"

DEPENDS = "git-native python3-mako-native boost \
           ncurses udev python3-requests \
           python3-setuptools-native"
RDEPENDS_${PN} += "python3-core python3-requests"
RDEPENDS_${PN}-tests = "${PN}"
RDEPENDS_${PN}-examples = "${PN}"
RDEPENDS_${PYTHON_PN}-${PN} = "${PN} python3-numpy"
RRECOMMENDS_${PN} += "uhd-fpga-images"

inherit cmake python3-dir python3native
require includes/maintainer-ettus.inc

S = "${WORKDIR}/git/host"

PACKAGES =+ "${PN}-tests ${PN}-examples ${PYTHON_PN}-${PN}"

INSANE_SKIP_${PN} = "dev-so"

FILES_${PN} += "${libdir}/libuhd.so \
                ${libdir}/uhd/utils/*"
FILES_${PN}-tests += "${datadir}/uhd/tests/*"
FILES_${PN}-dev += "${libdir}/cmake/*"
FILES_${PN}-dbg += "${libdir}/uhd/examples/.debug/* \
                    ${libdir}/uhd/utils/.debug/* \
                    ${libdir}/uhd/utils/latency/.debug/* \
                    ${libdir}/uhd/tests/.debug/* \
                    ${libdir}/uhd/usrp_e_utils/.debug/*"
FILES_${PN}-examples = "${libdir}/uhd/examples/*"
FILES_${PYTHON_PN}-${PN} = "${PYTHON_SITEPACKAGES_DIR}/uhd/*"

PACKAGECONFIG ??= "b100 b200 usrp1 usrp2 x300"
PACKAGECONFIG[staticlibs] = "-DENABLE_STATIC_LIBS=ON,-DENABLE_STATIC_LIBS=OFF "

PACKAGECONFIG[b100] = "-DENABLE_B100=ON,-DENABLE_B100=OFF, libusb1"
PACKAGECONFIG[b200] = "-DENABLE_B200=ON,-DENABLE_B200=OFF, libusb1"
PACKAGECONFIG[n230] = "-DENABLE_N230=ON,-DENABLE_N230=OFF, "
PACKAGECONFIG[usrp1] = "-DENABLE_USRP1=ON,-DENABLE_USRP1=OFF, libusb1"
PACKAGECONFIG[usrp2] = "-DENABLE_USRP2=ON,-DENABLE_USRP2=OFF, "
PACKAGECONFIG[x300] = "-DENABLE_X300=ON,-DENABLE_X300=OFF, "
PACKAGECONFIG[mpmd] = "-DENABLE_MPMD=ON,-DENABLE_MPMD=OFF"
PACKAGECONFIG[python] = "-DENABLE_PYTHON_API=ON,-DENABLE_PYTHON_API=OFF, python3-numpy-native"

EXTRA_OECMAKE = "-DENABLE_LIBUHD=TRUE \
                 -DRUNTIME_PYTHON_EXECUTABLE=/usr/bin/python3 \
                 -DENABLE_MAN_PAGES=OFF \
                 -DENABLE_MANUAL=OFF \
                "
