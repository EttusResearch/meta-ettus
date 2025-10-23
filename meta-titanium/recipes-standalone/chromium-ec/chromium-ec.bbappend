FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE:ni-titanium-ec = "ni-titanium-ec"
CROS_EC_BOARD:ni-titanium-ec = "titanium"

SRC_URI:ni-titanium-ec = " \
    git://github.com/EttusResearch/usrp-firmware.git;branch=titanium;protocol=https \
    file://0001-Makefile.toolchain-ignore-stringop-overread-warning.patch \
    file://0002-ignore-reprecation-warning-ftdi_usb_purge_buffers-is.patch \
    "

SRCREV:ni-titanium-ec = "82c52e33a801e19af7187b1cf8da36673778f12f"

PATCHTOOL = "git"

LIC_FILES_CHKSUM:ni-titanium-ec = "file://LICENSE;md5=877fdcdaa5a0636e67b479c79335a6d1"

do_compile:ni-titanium-ec() {
    oe_runmake BOARD=titanium
    oe_runmake BOARD=titanium-rev5
}

do_deploy:ni-titanium-ec() {
    install -m 0644 ${B}/build/titanium/ec.bin ${DEPLOYDIR}/ec-titanium-rev6.bin
    install -m 0644 ${B}/build/titanium/RW/ec.RW.bin ${DEPLOYDIR}/ec-titanium-rev6.RW.bin

    # rev7 files are just symlinks to rev6 since nothing changed between
    # rev 6 and 7 for the SCU.
    ln -sf ec-titanium-rev6.bin ${DEPLOYDIR}/ec-titanium-rev7.bin
    ln -sf ec-titanium-rev6.RW.bin ${DEPLOYDIR}/ec-titanium-rev7.RW.bin

    install -m 0644 ${B}/build/titanium-rev5/ec.bin ${DEPLOYDIR}/ec-titanium-rev5.bin
    install -m 0644 ${B}/build/titanium-rev5/RW/ec.RW.bin ${DEPLOYDIR}/ec-titanium-rev5.RW.bin
}
