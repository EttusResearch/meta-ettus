DESCRIPTION = "Base software to install GNU Radio"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r3"

inherit task

RDEPENDS_${PN} = "\
  gnuradio \
  gnuradio-dev \
  gnuradio-examples \
"
