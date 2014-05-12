SRC_URI = "git://github.com/EttusResearch/uhd-e300-dev.git;branch=e300/merge_usrp3;protocol=https"

SRCREV = "e5cd35e0dd5d41def21c18a423617e1a68c1794d"

EXTRA_OECMAKE += " -DENABLE_E300=TRUE"
