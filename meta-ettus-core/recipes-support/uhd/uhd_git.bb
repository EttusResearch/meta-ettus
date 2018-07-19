require recipes-support/uhd/uhd.inc

LIC_FILES_CHKSUM = "file://LICENSE;md5=8255adf1069294c928e0e18b01a16282"
PV = "3.13.0.0"

SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=master \
          "

SRCREV = "f114cfa0ddf70228d10462758c2b8e878c993f5d"

S = "${WORKDIR}/git/host"

