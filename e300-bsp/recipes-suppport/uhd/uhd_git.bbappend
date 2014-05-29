SRC_URI = "git://github.com/EttusResearch/uhd-e300-dev.git;branch=usrp3;protocol=https"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8255adf1069294c928e0e18b01a16282"

SRCREV = "38d72e960cc0e4d604223d6063317587698a2448"

PV = "3.7.1+git${SRCPV}"

EXTRA_OECMAKE += " -DENABLE_E300=TRUE"
