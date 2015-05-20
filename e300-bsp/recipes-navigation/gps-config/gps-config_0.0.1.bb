SUMMARY = "A TCP/IP Daemon simplifying the communication with GPS devices"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://gps_prep;md5=04eab20c395dd8e5cd8febbfa6dd56d8"
DEPENDS = "gpsd"

COMPATIBLE_MACHINE = "ettus-e300"

PACKAGE_ARCH = "${MACHINE_ARCH}"

S = "${WORKDIR}"

SRC_URI = " file://gpsd-default-e300 \
            file://gps_prep \
"

inherit update-rc.d

INITSCRIPT_NAME = "gps_prep"
INITSCRIPT_PARAMS = "defaults 34"


do_install() {
    install -d ${D}/${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/gps_prep ${D}/${sysconfdir}/init.d/
    install -d ${D}/${sysconfdir}/default
    install -m 0644 ${WORKDIR}/gpsd-default-e300 ${D}/${sysconfdir}/default/gpsd.default-e300
}

pkg_postinst_${PN}-conf() {
    update-alternatives --install ${sysconfdir}/default/gpsd gpsd-defaults ${sysconfdir}/default/gpsd.default-e300 20
}

pkg_postrm_${PN}-conf() {
    update-alternatives --remove gpsd-defaults ${sysconfdir}/default/gpsd.defaulti-e300
}

