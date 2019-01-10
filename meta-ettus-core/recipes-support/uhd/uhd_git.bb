require recipes-support/uhd/uhd.inc

LIC_FILES_CHKSUM = "file://LICENSE;md5=8255adf1069294c928e0e18b01a16282"
PV = "3.13.1.0"

SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.13 \
          "

SRCREV = "4a356623b46adf2117914c565d0322638912bb1a"

S = "${WORKDIR}/git/host"

