FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PMUFW_SHUTDOWN_PATCH = "file://0002-zynqmp_pmufw-signal-shutdown-by-driving-MIO-34-low.patch;striplevel=5"

SRC_URI_prepend = " \
    file://0001-zynqmp_pmufw-enable-wdt.patch;striplevel=5 \
    ${PMUFW_SHUTDOWN_PATCH} \
    "
