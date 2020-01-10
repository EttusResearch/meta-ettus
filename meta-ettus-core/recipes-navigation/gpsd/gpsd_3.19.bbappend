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
