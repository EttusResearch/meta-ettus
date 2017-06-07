do_install_append() {
	rm -f ${D}${sysconfdir}/tmpfiles.d/etc.conf
}
