include recipes-bsp/u-boot/u-boot-xlnx.inc

SRCREV = "664820b231b129552e963e1a96b45ac7196ccc81"
PV = "v2014.01${XILINX_EXTENSION}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

SRC_URI = " \
    git://github.com/Xilinx/u-boot-xlnx.git;protocol=https;branch=master-next \
"

SRC_URI_append_ettus-e300 = " file://ps7_init.h \
                              file://ps7_init.c \
                              file://0001-E300-Uses-UART0-for-console.patch \
                              file://0002-E300-Disable-QSPI.patch \
                              file://0003-Read-mac-address-from-i2c-EEPROM.patch \
                             "
SPL_BINARY = "boot.bin"
UBOOT_SUFFIX = "img"

LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

do_configure_prepend () {
	cp ${WORKDIR}/ps7_init.h ${S}/board/xilinx/zynq/
	cp ${WORKDIR}/ps7_init.c ${S}/board/xilinx/zynq/
}
