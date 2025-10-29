DESCRIPTION = "Extra machine specific configuration files for udev"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

INHIBIT_DEFAULT_DEPS = "1"

do_install:append() {
    install -d ${D}${sysconfdir}/udev/rules.d

    # deactivate "Predictable Network Interface Names"
    # see https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
    # When 75-net-description.rules is active, the RJ45 network interface is called end0
    # When 75-net-description.rules is masked, the RJ45 network interface is called eth0
    ln -s /dev/null ${D}${sysconfdir}/udev/rules.d/75-net-description.rules
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
