FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE_ni-titanium-ec = "ni-titanium-ec"
CROS_EC_BOARD_ni-titanium-ec = "titanium"

SRC_URI_ni-titanium-ec = "git://github.com/EttusResearch/usrp-firmware.git;branch=titanium"
SRCREV_ni-titanium-ec = "08eb22246e2048d98b10aaf9be19574fbc6af39b"

PATCHTOOL = "git"

LIC_FILES_CHKSUM_ni-titanium-ec = "file://LICENSE;md5=877fdcdaa5a0636e67b479c79335a6d1"

do_compile_ni-titanium-ec() {
    oe_runmake BOARD=titanium
    oe_runmake BOARD=titanium-rev5
}

do_deploy_ni-titanium-ec() {
    install -m 0644 ${B}/build/titanium/ec.bin ${DEPLOYDIR}/ec-titanium-rev6.bin
    install -m 0644 ${B}/build/titanium/RW/ec.RW.bin ${DEPLOYDIR}/ec-titanium-rev6.RW.bin

    install -m 0644 ${B}/build/titanium-rev5/ec.bin ${DEPLOYDIR}/ec-titanium-rev5.bin
    install -m 0644 ${B}/build/titanium-rev5/RW/ec.RW.bin ${DEPLOYDIR}/ec-titanium-rev5.RW.bin
}
