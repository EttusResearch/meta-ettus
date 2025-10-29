FILESEXTRAPATHS:prepend := "${THISDIR}/python3-mprpc:"

DEPENDS += "python3-cython-native"

ORIG_PV = "0.1.17"
PV = "0.1.17-f2"

S = "${WORKDIR}/mprpc-${ORIG_PV}"

do_compile:prepend() {
    cython3 mprpc/*.pyx
}
PYPI_SRC_URI = "https://files.pythonhosted.org/packages/source/m/mprpc/mprpc-${ORIG_PV}.tar.gz"
SRC_URI += " \
    file://0001-Remove-encoding-option-to-msgpack-calls.patch \
    file://0002-server.pyx-fix-import-errors-with-Python3.12.patch \
    "
