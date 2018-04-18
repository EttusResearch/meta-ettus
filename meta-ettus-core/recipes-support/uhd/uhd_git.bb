require recipes-support/uhd/uhd.inc

LIC_FILES_CHKSUM = "file://LICENSE;md5=8255adf1069294c928e0e18b01a16282"

PV = "3.12.0"

SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=master \
          "

SRCREV = "77b87095da830558d26d0832fc08b3320f564f12"

S = "${WORKDIR}/git/host"

