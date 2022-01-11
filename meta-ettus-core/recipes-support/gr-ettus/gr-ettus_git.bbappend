LIC_FILES_CHKSUM = "file://LICENSE;md5=c76e0564bc8dc86c9ce1fb80526c9f2a"

SRC_URI = "git://github.com/EttusResearch/gr-ettus.git;branch=maint-3.8-uhd4.0;protocol=https"
SRCREV = "30640b73960d6d29e8366d46aab4ef5273217175"

EXTRA_OECMAKE = "-DPYTHON_VERSION_MAJOR=3"
INSANE_SKIP_${PN} = "dev-so"

# Disable QT
PACKAGECONFIG = ""
