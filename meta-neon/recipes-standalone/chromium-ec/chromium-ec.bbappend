FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE:ni-neon-ec = "ni-neon-ec"
CROS_EC_BOARD:ni-neon-ec = "neon"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI:ni-neon-ec = " \
    git://github.com/EttusResearch/usrp-firmware.git;branch=neon;protocol=https \
    "

SRCREV:ni-neon-ec = "a190641b349b1bfdbdd9f471f82613971e50e375"

PATCHTOOL = "git"

LIC_FILES_CHKSUM:ni-neon-ec = "file://LICENSE;md5=562c740877935f40b262db8af30bca36"

do_compile:ni-neon-ec() {
    oe_runmake BOARD=neon
}

do_deploy:ni-neon-ec() {
    install -m 0644 ${B}/build/neon/ec.bin ${DEPLOYDIR}/ec-neon-rev3.bin
    install -m 0644 ${B}/build/neon/RW/ec.RW.bin ${DEPLOYDIR}/ec-neon-rev3.RW.bin
}
