SUMMARY = "E3XX series specific udev rules"

LICENSE = "PD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/PD;md5=b3597d12946881e13cb3b548d1173851"

SRC_URI = "file://99-discharging.rules file://99-temp.rules"

do_install() {
    install -d ${D}/etc/udev/rules.d
    install -m 0644 ${WORKDIR}/99-discharging.rules ${D}/etc/udev/rules.d/
    install -m 0644 ${WORKDIR}/99-temp.rules ${D}/etc/udev/rules.d/
}

FILES_${PN} = "/etc/udev"
