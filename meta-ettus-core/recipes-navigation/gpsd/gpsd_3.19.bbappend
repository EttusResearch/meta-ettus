FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# 1. Install and enable gpsdctl@ttyPS1.service

SRC_URI += " \
    file://make-gpsdctl-service-installable.patch \
    "

SYSTEMD_SERVICE_${PN} = "${BPN}.service ${BPN}.socket ${BPN}ctl@ttyPS1.service"
FILES_${PN}_append = " ${systemd_unitdir}/system/${BPN}ctl@.service"

# 2. provide cgps, gps2udp and gpsmon as separate packages

PACKAGES =+ "gps-utils-cgps gps-utils-gps2udp gps-utils-gpsmon"

SUMMARY_gps-utils-cgps = "Utils used for simulating, monitoring,... a GPS (cgps only)"
FILES_gps-utils-cgps = " \
    ${bindir}/cgps \
    "
SUMMARY_gps-utils-gps2udp = "Utils used for simulating, monitoring,... a GPS (gps2udp only)"
FILES_gps-utils-gps2udp = " \
    ${bindir}/gps2udp \
    "
SUMMARY_gps-utils-gpsmon = "Utils used for simulating, monitoring,... a GPS (gpsmon only)"
FILES_gps-utils-gpsmon = " \
    ${bindir}/gpsmon \
    "

RDEPENDS_gps-utils += "gps-utils-cgps gps-utils-gps2udp gps-utils-gpsmon"
