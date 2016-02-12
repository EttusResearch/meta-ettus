FILESEXTRAPATHS_prepend_ettus-e300 := "${THISDIR}/ettus-e300:"

PACKAGE_ARCH_ettus-e300 = "${MACHINE_ARCH}"

SRC_URI_append_ettus-e300 = " file://powerbutton.sh file://powerbutton"

do_install_append_ettus-e300() {
	install -m 0644 ${WORKDIR}/powerbutton ${D}/${sysconfdir}/acpi/events
	install -m 0755 ${WORKDIR}/powerbutton.sh ${D}/${sysconfdir}/acpi
	sed -i  '/proc\/acpi/d' ${D}/${sysconfdir}/init.d/acpid
}
