FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

SRC_URI_append_ettus-e200 = "\
                  file://axi_fpga.scc \
                  file://ettus-e200-standard.scc \
		  file://e200-devicetree.dts \
		"

MACHINE_DEVICETREE_ettus-e200 = "e200-devicetree.dts"

COMPATIBLE_MACHINE_ettus-e200 = "ettus-e200"

