FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}-3.14:"

SRC_URI_append_ettus-e300 = "\
                  file://axi-fpga.scc \
                  file://axi-fpga.cfg \
                  file://0001-axi_fpga-Add-a-driver-to-test-AXI-interface-to-the-f.patch \
                  file://ettus-e300.scc \
                  file://ettus-e300.cfg \
                  file://usb-audio.cfg \
		  file://e300-devicetree.dts \
		"

COMPATIBLE_MACHINE_ettus-e300 = "ettus-e300"

