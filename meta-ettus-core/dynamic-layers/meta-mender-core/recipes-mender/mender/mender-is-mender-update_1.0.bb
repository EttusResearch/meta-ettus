DESCRIPTION = "Provide command mender by symlinking to mender-update"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

inherit allarch

INHIBIT_DEFAULT_DEPS = "1"

RDEPENDS:${PN} = "mender-update"

do_install:append() {
    install -d ${D}${bindir}
    ln -s mender-update ${D}${bindir}/mender
}
