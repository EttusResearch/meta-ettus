FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

SRC_URI_append_ettus-e300 = "file://powerbutton.sh file://powerbutton"

do_install_append() {
	install -m 0644 ${WORKDIR}/powerbutton ${D}/${sysconfdir}/acpi/events
	install -m 0755 ${WORKDIR}/powerbutton.sh ${D}/${sysconfdir}/acpi
}
