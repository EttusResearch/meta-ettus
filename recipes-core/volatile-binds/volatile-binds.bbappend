do_install_append() {
	rm ${D}${sysconfdir}/tmpfiles.d/etc.conf
}
