require recipes-support/uhd/uhd.inc

LIC_FILES_CHKSUM = "file://LICENSE;md5=8255adf1069294c928e0e18b01a16282"
PV = "3.13.0.2"

SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.13 \
          "

SRCREV = "78745bda5de0beed0411c4b1baf3783d84090024"

S = "${WORKDIR}/git/host"

