DESCRIPTION = "unittest-based test runner with Ant/JUnit like XML reporting"
HOMEPAGE = "https://github.com/xmlrunner/unittest-xml-reporting"
SECTION = "devel/python"

LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD;md5=3775480a712fc46a69647678acb234cb"

PYPI_PACKAGE := "unittest-xml-reporting"

inherit pypi

SRC_URI[md5sum] = "cecf150fa544e9ba0d67b20e450cce17"
SRC_URI[sha256sum] = "9d28ddf6524cf0ff9293f61bd12e792de298f8561a5c945acea63fb437789e0e"

BBCLASSEXTEND = "native"

RDEPENDS_${PN} = " \
    ${PYTHON_PN}-core \
    ${PYTHON_PN}-six \
    "

RPROVIDES_${PN} = " \
    ${PYTHON_PN}-xmlrunner"
