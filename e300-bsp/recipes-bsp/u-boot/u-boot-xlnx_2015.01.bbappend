FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-xlnx/${MACHINE}:"


SRC_URI_append_ettus-e300 = " file://ps7_init.h \
                              file://ps7_init.c \
                              file://0001-E300-Uses-UART0-for-console.patch \
                              file://0002-E300-Disable-QSPI.patch \
                              file://0003-Read-mac-address-from-i2c-EEPROM.patch \
                              file://0001-e300-Added-memory-test.patch \
                              file://uEnv.txt \
                              file://fpga.bin \
                             "

do_deploy_append() {
	if test -e ${WORKDIR}/fpga.bin; then
		cp ${WORKDIR}/fpga.bin ${DEPLOYDIR}
	fi
}
