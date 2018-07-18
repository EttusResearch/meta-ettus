require u-boot_2018.01.inc

do_compile_append() {
	ln -sf ${B}/spl/${SPL_BINARY} ${B}/${SPL_BINARY}
}
