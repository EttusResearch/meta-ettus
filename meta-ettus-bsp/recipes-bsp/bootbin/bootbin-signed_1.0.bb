DESCRIPTION = "Precompiled boot.bin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit uhd_images_downloader
inherit deploy

SRC_URI = "file://manifest.txt"

FILES:${PN} = "${BOOTBIN_DIR}/${BOOTBIN_PRECOMPILED_NAME}"

COMPATIBLE_MACHINE = "ni-titanium"

PACKAGE_ARCH = "${MACHINE_ARCH}"

UHD_MANIFEST_FILE = "${WORKDIR}/manifest.txt"
UHD_IMAGES_TO_DOWNLOAD = "x4xx-boot-bin"

do_compile() {
    # directory ${S} is identical with ${B}
    # install -m 0644 ${S}/boot.bin ${B}/boot.bin
    ls -l ${B}/boot.bin
}

do_install() {
    install -d ${D}/${BOOTBIN_DIR}
    install -m 0644 ${B}/boot.bin ${D}/${BOOTBIN_DIR}/${BOOTBIN_PRECOMPILED_NAME}
}

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0644 ${B}/boot.bin ${DEPLOYDIR}/${BOOTBIN_PRECOMPILED_NAME}
}

addtask deploy after do_compile
