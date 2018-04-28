FILESEXTRAPATHS_prepend_ni-e31x := "${THISDIR}/u-boot-2018.01:"

# Make sure this is an append, otherwise this might get applied before the BSP patches
SRC_URI_append_ni-e31x = " \
           file://0002-ni-zynq-Mender.io-support-for-NI-Ettus-Research-E31x.patch \
           "
