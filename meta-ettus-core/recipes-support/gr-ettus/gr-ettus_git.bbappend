LIC_FILES_CHKSUM = "file://LICENSE;md5=c76e0564bc8dc86c9ce1fb80526c9f2a"

SRC_URI = "git://github.com/EttusResearch/gr-ettus.git;branch=maint-3.8"
SRCREV = "3c5eab14e47536acc8375128406915f8ffa9a2ff"

EXTRA_OECMAKE = "-DPYTHON_VERSION_MAJOR=3"
INSANE_SKIP_${PN} = "dev-so"

# Disable QT
PACKAGECONFIG = ""
