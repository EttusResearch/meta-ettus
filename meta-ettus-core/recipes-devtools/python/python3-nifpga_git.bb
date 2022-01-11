SUMMARY = "NI FPGA Interface Python API"
HOMEPAGE = "https://github.com/ni/nifpga-python"
SECTION = "devel/python"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8275bea59423b927c5ea127b830bf491"

PV = "20.0.0+git${SRCPV}"
SRCREV = "588ac49c8103e806eaaf45841f3c538d1acff59e"
SRC_URI = " \
    git://github.com/ni/nifpga-python;protocol=https \
    file://0001-nifpga-patch-library-name.patch \
    "

S = "${WORKDIR}/git"

RDEPENDS_${PN} = " \
    ${PYTHON_PN}-future \
    "

inherit setuptools3
