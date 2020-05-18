FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-e31x-mender = " \
    file://mender-device-identity \
    file://mender-inventory-serial \
"

SYSTEMD_AUTO_ENABLE ?= "disable"

do_install_append_ni-e31x-mender() {
	install -m 0755 ${WORKDIR}/mender-device-identity ${D}/${datadir}/mender/identity/mender-device-identity
	install -m 0755 ${WORKDIR}/mender-inventory-serial ${D}/${datadir}/mender/inventory/mender-inventory-serial
}
