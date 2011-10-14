require recipes/linux/linux.inc

DESCRIPTION = "Linux kernel for OMAP processors"
KERNEL_IMAGETYPE = "uImage"

COMPATIBLE_MACHINE = "usrp-e1xx"

FILESPATHPKG_prepend = "linux-usrp-embedded-3.0-pm:"

PV = "3.0-pm"
#MACHINE_KERNEL_PR_append = "a"

SRCREV = "0b7e5a3b036013d4b1b9e183df40c7fbd8d51944"
SRC_URI = "git://www.sakoman.com/git/linux-omap-2.6.git;branch=omap-3.0-pm;protocol=git \
	file://0001-Add-defines-to-set-config-options-in-GPMC-per-CS-con.patch \
	file://0002-Add-functions-to-dma.c-to-set-address-and-length-for.patch \
	file://0003-Add-defconfig-to-save-working-kernel-.config.patch \
	file://0004-usrp_e-Add-driver-for-USRP-E1XX-FPGA-interface.patch \
	file://0005-usrp_e-Modify-overo-board-file-to-setup-hardware-for.patch \
	file://defconfig \
	"

S = "${WORKDIR}/git"

