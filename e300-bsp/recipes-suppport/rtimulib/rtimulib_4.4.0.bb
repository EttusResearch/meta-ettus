SUMMARY = "Simple program to connect a 9-dof IMU to an embedded Linux system."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=37115da1c12308918756b9c3b42627c8"

SRC_URI = "git://github.com/balister/RTIMULib.git;protocol=http \
           file://0001-If-ini-file-is-not-found-in-the-current-working-dire.patch \
           "

SRC_URI_append_ettus-e300 = " file://RTIMULib.ini"

SRCREV = "fe59096a7a3c96a4465be3dec39e059b23469e2a"

S = "${WORKDIR}/git"

DEPENDS = "qt4-x11-free"

EXTRA_OECMAKE = " \
                 -DQT_HEADERS_DIR=${STAGING_INCDIR}/qt4 \
                 -DQT_QTCORE_INCLUDE_DIR=${STAGING_INCDIR}/qt4/QtCore \
                 -DQT_LIBRARY_DIR=${STAGING_LIBDIR} \
                 -DQT_QTCORE_LIBRARY_RELEASE=${STAGING_LIBDIR}/libQtCore.so \
                 -DQT_QTGUI_LIBRARY_RELEASE=${STAGING_LIBDIR}/libQtGui.so \
                "

inherit cmake 

do_install_append() {
	install -d ${D}/${sysconfdir}
	install -m 0644 ${WORKDIR}/RTIMULib.ini ${D}/${sysconfdir}
}

SOLIBS = ".so"
SOLIBSDEV = "xxx"

PACKAGES =+ "${PN}-conf"

FILES_${PN}-conf = "${sysconfdir}/RTIMULib.ini"
