SRC_URI = "git://github.com/EttusResearch/uhd-e300-dev.git;branch=usrp3;protocol=https"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8255adf1069294c928e0e18b01a16282"

SRCREV = "72cc104c4b465d0149e814bc7142cac9e2d41a0c"

PV = "3.7.1"

EXTRA_OECMAKE += " -DENABLE_E300=TRUE"
