require recipes-bsp/u-boot/u-boot.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=1707d6db1d42237583f50183a5651ecb"

COMPATIBLE_MACHINE = "(usrp-e1xx)"

SRC_URI = "ftp://ftp.denx.de/pub/u-boot/u-boot-2011.12.tar.bz2"
SRC_URI_append_usrp-e1xx ="\
        file://0001-net-eth.c-Restore-previous-behavior-for-eth_getenv_e.patch \
        file://0002-OMAP3-overo-Set-default-mpurate-to-720-use-for-usrp-.patch \
        file://0001-Revert-armv7-disable-L2-cache-in-cleanup_before_linu.patch \
        "

SRC_URI[md5sum] = "7f29b9f6da44d6e46e988e7561fd1d5f"
SRC_URI[sha256sum] = "41820d65eb848411f71b9222957b3532607be0a754da916067876194148b907c"

TARGET_LDFLAGS = ""

inherit base

S = "${WORKDIR}/u-boot-2011.12"

do_compile () {
       oe_runmake ${UBOOT_MACHINE}
       oe_runmake all
}

