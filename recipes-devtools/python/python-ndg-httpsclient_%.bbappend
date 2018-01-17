do_install_append() {
	rm ${D}${bindir_native}/ndg_httpclient
	rmdir ${D}${bindir_native}
}
