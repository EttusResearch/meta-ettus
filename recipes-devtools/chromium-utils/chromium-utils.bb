SUMMARY = "Chromium EC utilities"
DEPENDS = "libftdi libusb"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=562c740877935f40b262db8af30bca36"

SRCREV = "a7bf207add71cfb20308ed6858b1b028c866304a"
SRC_URI = "git://chromium.googlesource.com/chromiumos/platform/ec;protocol=https \
          "

PV = "1.1.9999+gitr${SRCPV}"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = "'HOSTCC=${CC}' 'HOSTCFLAGS=${CFLAGS}' 'HOST_LDFLAGS=${LDFLAGS}'"

do_compile() {
    oe_runmake utils
}

do_install() {
    install -m 0755 -d ${D}${sbindir}
    install -m 0755 ${S}/build/bds/util/ectool ${D}${sbindir}/ectool
}
