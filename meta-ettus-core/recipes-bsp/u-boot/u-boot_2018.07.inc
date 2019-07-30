FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_prepend = " \
    file://0001-misc-cros_ec-Add-trivial-support-for-software-sync.patch \
"

PATCHTOOL = "git"
