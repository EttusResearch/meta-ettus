FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-watchdog-use-dev-watchdog0-only-if-it-exists.patch \
    "
