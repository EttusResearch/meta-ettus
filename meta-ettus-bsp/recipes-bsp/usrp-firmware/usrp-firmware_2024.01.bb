SUMMARY = "Firmware for Ettus Research products."
HOMEPAGE = "http://www.ettus.com"
LICENSE = "GPL-3.0-or-later"

inherit deploy

PACKAGE_ARCH = "${MACHINE_ARCH}"

# Override source variable from ${WORKDIR}/${PN}-${PV} to ${WORKDIR}
# This makes sure license files identified by NO_GENERIC_LICENSE 
# are found at ${S} by the spdx SBOM generator 
S = "${WORKDIR}"

FILESEXTRAPATHS:prepend:ni-neon := "${BINARYDIR}/ni-neon:"
FILESEXTRAPATHS:prepend:ni-sulfur := "${BINARYDIR}/ni-sulfur:"
FILESEXTRAPATHS:prepend:ni-titanium := "${BINARYDIR}/ni-titanium:"

SRC_URI:append:ni-neon = " \
                   file://ec-neon-rev1.RW.bin \
                   file://ec-neon-rev2.RW.bin \
                   file://ec-neon-rev3.RW.bin \
                   file://LICENSE.ec-neon \
                 "

SRC_URI:append:ni-sulfur = " \
                   file://ec-sulfur-rev3.bin \
                   file://ec-sulfur-rev3.RW.bin \
                   file://ec-sulfur-rev5.bin \
                   file://ec-sulfur-rev5.RW.bin \
                   file://LICENSE.ec-sulfur \
                   file://mykonos-m3.bin \
                 "

SRC_URI:append:ni-titanium = " \
                   file://ec-titanium-rev4.bin \
                   file://ec-titanium-rev4.RW.bin \
                   file://LICENSE.ec-titanium \
                 "

EXTRA_PACKAGES:ni-e31x = ""
EXTRA_PACKAGES:ni-neon += " \
    ${PN}-ni-neon \
    ${PN}-ni-neon-license \
    "
EXTRA_PACKAGES:ni-sulfur += " \
    ${PN}-ni-sulfur \
    ${PN}-ni-sulfur-license \
    ${PN}-adi-mykonos \
    "
EXTRA_PACKAGES:ni-titanium += " \
    ${PN}-ni-titanium \
    ${PN}-ni-titanium-license \
    "

PACKAGE_BEFORE_PN = "${EXTRA_PACKAGES}"
RDEPENDS:${PN} += "${EXTRA_PACKAGES}"

ALLOW_EMPTY:${PN}:ni-e31x = "1"
ALLOW_EMPTY:${PN}:ni-neon = "1"
ALLOW_EMPTY:${PN}:ni-sulfur = "1"
ALLOW_EMPTY:${PN}:ni-titanium = "1"

# The EC image is under the Chromium License, so add custom license file

LICENSE:append:ni-sulfur = " & Firmware-ni-sulfur"
LIC_FILES_CHKSUM:append:ni-sulfur = "file://${WORKDIR}/LICENSE.ec-sulfur;md5=72f855f00b364ec8bdc025e1a36b39c3"

FILES:${PN}-ni-sulfur-license = " \
    ${nonarch_base_libdir}/firmware/ni/LICENSE.ec-sulfur \
    "
FILES:${PN}-ni-sulfur = " \
    ${nonarch_base_libdir}/firmware/ni/ec-sulfur*.bin \
    ${nonarch_base_libdir}/firmware/ni/ec-phosphorus*.bin \
    "
NO_GENERIC_LICENSE[Firmware-ni-sulfur] = "LICENSE.ec-sulfur"
LICENSE:${PN}-ni-sulfur = "Firmware-ni-sulfur"
RDEPENDS:${PN}-ni-sulfur += "${PN}-ni-sulfur-license"

FILES:${PN}-adi-mykonos = " \
    ${nonarch_base_libdir}/firmware/adi/mykonos-m3.bin \
    "
LICENSE:${PN}-adi-mykonos = "CLOSED"


# The EC image is under the Chromium License, so add custom license file

LICENSE:append:ni-neon = " & Firmware-ni-neon"
LIC_FILES_CHKSUM:append:ni-neon = "file://${WORKDIR}/LICENSE.ec-neon;md5=72f855f00b364ec8bdc025e1a36b39c3"

NO_GENERIC_LICENSE[Firmware-ni-neon] = "LICENSE.ec-neon"
LICENSE:${PN}-ni-neon = "Firmware-ni-neon"

FILES:${PN}-ni-neon-license = " \
                        ${nonarch_base_libdir}/firmware/ni/LICENSE.ec-neon \
                        "
FILES:${PN}-ni-neon = "${nonarch_base_libdir}/firmware/ni/ec-neon-rev*.RW.bin \
                      "
RDEPENDS:${PN}-ni-neon += "${PN}-ni-neon-license"


LICENSE:append:ni-titanium = " & Firmware-ni-titanium"
LIC_FILES_CHKSUM:append:ni-titanium = "file://${WORKDIR}/LICENSE.ec-titanium;md5=72f855f00b364ec8bdc025e1a36b39c3"

NO_GENERIC_LICENSE[Firmware-ni-titanium] = "LICENSE.ec-titanium"
LICENSE:${PN}-ni-titanium = "Firmware-ni-titanium"

FILES:${PN}-ni-titanium-license = " \
                        ${nonarch_base_libdir}/firmware/ni/LICENSE.ec-titanium \
                        "
FILES:${PN}-ni-titanium = " \
                       ${nonarch_base_libdir}/firmware/ni/ec-titanium-rev*.bin \
                       ${nonarch_base_libdir}/firmware/ni/ec-titanium-rev*.RW.bin \
                       "
RDEPENDS:${PN}-ni-titanium += "${PN}-ni-titanium-license"

do_install:append:ni-sulfur() {

    ### Microcontroller firmware

    # legacy rev. 3 firmware
    install -D -m 0644 ${WORKDIR}/ec-sulfur-rev3.bin ${D}${nonarch_base_libdir}/firmware/ni/ec-sulfur-rev3.bin
    install -m 0644 ${WORKDIR}/ec-sulfur-rev3.RW.bin ${D}${nonarch_base_libdir}/firmware/ni/ec-sulfur-rev3.RW.bin

    # Rev5+ firmware now differs from rev3 firmware, since it adds more margin in bootdelay
    # Rev 10+ firmware uses GPIOs which can en-/disable the 12V of the daughter cards and the fans
    # Rev 4+ all use the same firmware
    install -D -m 0644 ${WORKDIR}/ec-sulfur-rev5.bin ${D}${nonarch_base_libdir}/firmware/ni/ec-sulfur-rev5.bin
    install -m 0644 ${WORKDIR}/ec-sulfur-rev5.RW.bin ${D}${nonarch_base_libdir}/firmware/ni/ec-sulfur-rev5.RW.bin

    for REV in 4 6 7 8 9 10 11
    do
      ln -sf ec-sulfur-rev5.bin ${D}${nonarch_base_libdir}/firmware/ni/ec-sulfur-rev${REV}.bin
      ln -sf ec-sulfur-rev5.RW.bin ${D}${nonarch_base_libdir}/firmware/ni/ec-sulfur-rev${REV}.RW.bin
    done

    for REV in 4 5 6 7 8 9 10 11
    do
      ln -sf ec-sulfur-rev5.bin ${D}${nonarch_base_libdir}/firmware/ni/ec-phosphorus-rev${REV}.bin
      ln -sf ec-sulfur-rev5.RW.bin ${D}${nonarch_base_libdir}/firmware/ni/ec-phosphorus-rev${REV}.RW.bin
    done

    install -m 0644 ${WORKDIR}/LICENSE.ec-sulfur ${D}${nonarch_base_libdir}/firmware/ni/LICENSE.ec-sulfur

    install -D -m 0644 ${WORKDIR}/mykonos-m3.bin ${D}${nonarch_base_libdir}/firmware/adi/mykonos-m3.bin
}

do_install:append:ni-neon() {
    install -D -m 0644 -v ${WORKDIR}/ec-neon-rev1.RW.bin ${D}${nonarch_base_libdir}/firmware/ni/ec-neon-rev1.RW.bin
    install -D -m 0644 -v ${WORKDIR}/ec-neon-rev2.RW.bin ${D}${nonarch_base_libdir}/firmware/ni/ec-neon-rev2.RW.bin

    # install embedded controller (ec) firmware
    if [ -n "${CROS_EC_DEPLOY_DIR_IMAGE}" ]; then
        install -m 0644 -v ${CROS_EC_DEPLOY_DIR_IMAGE}/ec-neon-rev3.RW.bin ${D}${nonarch_base_libdir}/firmware/ni/
    else
        install -m 0644 -v ${WORKDIR}/ec-neon-rev3.RW.bin ${D}${nonarch_base_libdir}/firmware/ni/
    fi

    install -m 0644 -v ${WORKDIR}/LICENSE.ec-neon ${D}${nonarch_base_libdir}/firmware/ni/LICENSE.ec-neon
}

CROS_EC_DEPLOY_DIR_IMAGE:ni-titanium ?= "${TOPDIR}/tmp-stm32-baremetal/deploy/images/ni-titanium-ec-rev5"

python __anonymous() {
    if "ni-neon-ec" in (d.getVar('BBMULTICONFIG') or "").split(' '):
        d.appendVarFlag('do_install', 'mcdepends', ' mc::ni-neon-ec:chromium-ec:do_deploy')
        d.setVar('CROS_EC_DEPLOY_DIR_IMAGE', '${TOPDIR}/tmp-stm32-baremetal/deploy/images/ni-neon-ec-rev3')
    if "ni-titanium-ec" in (d.getVar('BBMULTICONFIG') or "").split(' '):
        d.appendVarFlag('do_install', 'mcdepends', ' mc::ni-titanium-ec:chromium-ec:do_deploy')
}

do_install:append:ni-titanium() {
    # install rev 4 firmware binaries
    install -D -m 0644 ${WORKDIR}/ec-titanium-rev4.bin ${D}${nonarch_base_libdir}/firmware/ni/ec-titanium-rev4.bin
    install -D -m 0644 ${WORKDIR}/ec-titanium-rev4.RW.bin ${D}${nonarch_base_libdir}/firmware/ni/ec-titanium-rev4.RW.bin

    # install embedded controller (ec) firmware
    install -m 0644 ${CROS_EC_DEPLOY_DIR_IMAGE}/ec-titanium-rev*.bin ${D}${nonarch_base_libdir}/firmware/ni/

    install -D -m 0644 ${WORKDIR}/LICENSE.ec-titanium ${D}${nonarch_base_libdir}/firmware/ni/LICENSE.ec-titanium
}

do_deploy() {
}
do_deploy:ni-neon() {
    install -d ${DEPLOYDIR}
    install ${D}${nonarch_base_libdir}/firmware/ni/*.bin ${DEPLOYDIR}
}
do_deploy:ni-sulfur() {
    install -d ${DEPLOYDIR}
    install ${D}${nonarch_base_libdir}/firmware/ni/*.bin ${DEPLOYDIR}
}
do_deploy:ni-titanium() {
    install -d ${DEPLOYDIR}
    install ${D}${nonarch_base_libdir}/firmware/ni/*.bin ${DEPLOYDIR}
}
addtask deploy before do_build after do_install
