MPM_DEVICE_ni-neon = "e320"

RDEPENDS_${PN}_append_ni-neon = " \
    linux-firmware-ni-neon-fpga \
"

FILESEXTRAPATHS_prepend_ni-neon := "${THISDIR}/files:"

SRC_URI_append_ni-neon = " file://0001-E320-Update-max-rev-to-4.patch "

PR_ni-neon = "r2"