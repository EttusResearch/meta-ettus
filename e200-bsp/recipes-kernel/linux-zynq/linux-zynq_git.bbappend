FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

SRC_URI_append = "file://0001-Add-code-for-Marvell-88E1512-ethernet-phy-from-NI-ke.patch \
		  file://0001-e200-Add-a-board-file.patch \
		  file://defconfig \
		  file://e200-devicetree.dts \
		"

KERNEL_DEVICETREE = "${WORKDIR}/e200-devicetree.dts"

COMPATIBLE_MACHINE = "(ettus-e200)"

