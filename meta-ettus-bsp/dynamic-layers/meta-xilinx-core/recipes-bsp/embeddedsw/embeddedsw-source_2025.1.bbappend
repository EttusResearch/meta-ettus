FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-zynqmp-fsbl-usb-invalidate-dcache-after-csu-dma-copy.patch \
    "
