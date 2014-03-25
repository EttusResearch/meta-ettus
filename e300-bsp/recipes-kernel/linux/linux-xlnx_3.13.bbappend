FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}-3.13:"

SRC_URI_append_ettus-e300 = "\
                  file://ettus-e300.scc \
                  file://ettus-e300.cfg \
		  file://e300-devicetree.dts \
		"

#MACHINE_DEVICETREE_ettus-e300 = "e300-devicetree.dts"

COMPATIBLE_MACHINE_ettus-e300 = "ettus-e300"

