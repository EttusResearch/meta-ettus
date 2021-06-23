FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE_ni-titanium-ec = "ni-titanium-ec"
CROS_EC_BOARD_ni-titanium-ec = "titanium"

SRC_URI_ni-titanium-ec = "git://github.com/EttusResearch/usrp-firmware.git;branch=titanium"
SRCREV_ni-titanium-ec = "08eb22246e2048d98b10aaf9be19574fbc6af39b"

PATCHTOOL = "git"

LIC_FILES_CHKSUM_ni-titanium-ec = "file://LICENSE;md5=877fdcdaa5a0636e67b479c79335a6d1"

do_compile_ni-titanium-ec() {
    oe_runmake BOARD=${CROS_EC_BOARD}
}
