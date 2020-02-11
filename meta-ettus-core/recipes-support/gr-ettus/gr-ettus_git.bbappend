LIC_FILES_CHKSUM = "file://LICENSE;md5=ac2279a26595f08aba99c022f96e6aa9"

SRC_URI = "git://github.com/EttusResearch/gr-ettus.git;branch=master-next"
SRCREV = "ba14f5d8748ae9eade7cd563e19a7ce679b5e9a0"

EXTRA_OECMAKE = "-DPYTHON_VERSION_MAJOR=3"

# Disable QT
PACKAGECONFIG = ""
