require u-boot_2017.09.inc

do_compile_append() {
	ln -sf ${B}/spl/${SPL_BINARY} ${B}/${SPL_BINARY}
}
