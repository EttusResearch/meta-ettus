PACKAGES =+ "gps-utils-cgps gps-utils-gps2udp"

SUMMARY_gps-utils-cgps = "Utils used for simulating, monitoring,... a GPS (cgps only)"
FILES_gps-utils-cgps = " \
    ${bindir}/cgps \
    "
SUMMARY_gps-utils-gps2udp = "Utils used for simulating, monitoring,... a GPS (gps2udp only)"
FILES_gps-utils-gps2udp = " \
    ${bindir}/gps2udp \
    "

RDEPENDS_gps-utils += "gps-utils-cgps gps-utils-gps2udp"
