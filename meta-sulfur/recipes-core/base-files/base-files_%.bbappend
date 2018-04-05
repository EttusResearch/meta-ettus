FILESEXTRAPATHS_prepend_ni-sulfur := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " file://rfnoc-ports.conf \
                           "
do_install_append_ni-sulfur() {
	install -D -m 0644 ${WORKDIR}/rfnoc-ports.conf ${D}/${sysconfdir}/sysctl.d/rfnoc-ports.conf
}
