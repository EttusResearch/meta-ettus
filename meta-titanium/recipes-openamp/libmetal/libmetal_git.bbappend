FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRCREV = "f1e8154b6392838a7c68871ab03400112b1e59b7"

SRC_URI_append = " \
                 file://0001-linux-device-unmap-regions-for-linux-device.patch \
                 "
