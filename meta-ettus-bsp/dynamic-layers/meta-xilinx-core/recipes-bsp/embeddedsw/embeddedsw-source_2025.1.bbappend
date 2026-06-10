FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-zynqmp-fsbl-usb-invalidate-dcache-after-csu-dma-copy.patch \
    file://0002-sw_services-xilfpga-don-t-implicitly-remove-OCM-auth.patch \
    file://0003-xilfpga-don-t-allow-bitstream-authentication-in-DDR.patch \
    "
