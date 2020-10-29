SUMMARY = "Gnuplot-based plotting for numpy"
HOMEPAGE = "http://github.com/dkogan/gnuplotlib"
LICENSE = "LGPLv3+"
SECTION = "devel/python"
LIC_FILES_CHKSUM = "file://PKG-INFO;beginline=8;endline=8;md5=1c1d291aeb6058cb8b4c03594bb5adfa"

RDEPENDS_${PN} += "gnuplot ${PYTHON_PN}-numpysane"

inherit pypi
