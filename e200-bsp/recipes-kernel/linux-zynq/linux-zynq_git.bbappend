FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

SRC_URI_append = "\
                  file://e200.scc \
                  file://axi_fpga.scc \
		  file://defconfig \
		  file://e200-devicetree.dts \
		"

KERNEL_DEVICETREE = "${WORKDIR}/e200-devicetree.dts"

COMPATIBLE_MACHINE_ettus-e200 = "ettus-e200"

