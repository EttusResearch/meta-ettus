require recipes/linux/linux.inc

DESCRIPTION = "Linux kernel for OMAP processors"
KERNEL_IMAGETYPE = "uImage"

COMPATIBLE_MACHINE = "usrp-e1xx"


FILESPATHPKG_prepend = "linux-usrp-embedded-2.6.35:"

PV = "2.6.35"

SRCREV = "aef7efb09a04fb026ad3c30822d4d5193ba3cb3f"
SRC_URI = "git://www.sakoman.com/git/linux-omap-2.6.git;branch=omap3-2.6.35;protocol=git \
           file://0001-Add-defines-to-set-config-options-in-GPMC-per-CS-con.patch \
           file://0002-Add-functions-to-dma.c-to-set-address-and-length-for.patch \
           file://0003-Add-defconfig-to-save-working-kernel-.config.patch \
           file://0004-usrp-embedded-Add-driver-for-USRP-Embedded-FPGA-inte.patch \
	   file://defconfig"

S = "${WORKDIR}/git"

