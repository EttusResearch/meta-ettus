require recipes/linux/linux.inc

DESCRIPTION = "Linux kernel for OMAP processors"
KERNEL_IMAGETYPE = "uImage"

COMPATIBLE_MACHINE = "usrp-e1xx"

DEFAULT_PREFERENCE = "-1"

FILESPATHPKG_prepend = "linux-usrp-e1xx-git:"

PV = "2.6.35"

SRC_URI = "file:///home/balister/src/git/linux-omap-2.6-export \
	   file://defconfig"

S = "${WORKDIR}/linux-omap-2.6-export"

