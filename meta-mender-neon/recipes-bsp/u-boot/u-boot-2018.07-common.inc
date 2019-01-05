FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Make sure this is an append, otherwise this might get applied before the BSP patches
SRC_URI_append_ni-neon-rev1-mender = " \
           file://0001-ni-zynq-Mender.io-support-for-NI-Ettus-Research-Neon.patch \
"

SRC_URI_append_ni-neon-rev2-mender = " \
           file://0002-ni-zynq-Mender.io-support-for-NI-Ettus-Research-Neon.patch \
"
