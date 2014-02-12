FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

SRC_URI_append_ettus-e200 = "\
                  file://ettus-e200.scc \
                  file://axi_fpga.scc \
		  file://e200-devicetree.dts \
		"

MACHINE_DEVICETREE_ettus-e200 = "e200-devicetree.dts"

COMPATIBLE_MACHINE_ettus-e200 = "ettus-e200"

