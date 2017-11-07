require u-boot_2017.09.inc

SRC_URI_append_ettus-e3xx-sg1 = " \
		 file://fpga-1.bin \
		 "
SRC_URI_append_ettus-e3xx-sg3 = " \
		 file://fpga-3.bin \
		 "


do_compile_append() {
	ln -sf ${B}/spl/${SPL_BINARY} ${B}/${SPL_BINARY}
}

do_deploy_append_ettus-e3xx-sg1() {
	cp ${WORKDIR}/fpga-1.bin ${DEPLOYDIR}/fpga.bin
}

do_deploy_append_ettus-e3xx-sg3() {
	cp ${WORKDIR}/fpga-3.bin ${DEPLOYDIR}/fpga.bin
}
