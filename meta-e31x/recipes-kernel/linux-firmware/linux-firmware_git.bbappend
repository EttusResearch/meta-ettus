
PACKAGES_append_ni-e31x-sg1 = " \
    ${PN}-ni-e31x-sg1-fpga \
    "
PACKAGES_append_ni-e31x-sg3 = " \
    ${PN}-ni-e31x-sg3-fpga \
    "

# The FPGA images are provided by the uhd-fpga-images recipe
ALLOW_EMPTY_${PN}-ni-e31x-sg1-fpga = "1"
RDEPENDS_${PN}-ni-e31x-sg1-fpga = "uhd-fpga-images-e310-sg1-firmware"

ALLOW_EMPTY_${PN}-ni-e31x-sg3-fpga = "1"
RDEPENDS_${PN}-ni-e31x-sg3-fpga = "uhd-fpga-images-e310-sg3-firmware"
