DESCRIPTION = "Script to apply an overlay from the commandline"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PR="r0"
PV="0.10"

SRC_URI = "file://overlay \
          "

LICENSE = "CLOSED"

S = "${WORKDIR}"

do_install() {
	install -D -m 0755 ${WORKDIR}/overlay ${D}/usr/sbin/overlay
}

RDEPENDS_${PN} = "bash"
