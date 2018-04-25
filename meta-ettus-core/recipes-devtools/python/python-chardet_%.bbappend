do_install_append() {
	rm ${D}${bindir_native}/chardetect
	rmdir ${D}${bindir_native}
}
