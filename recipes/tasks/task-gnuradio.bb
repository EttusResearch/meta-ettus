DESCRIPTION = "Base software to install GNU Radio"

PR = "r3"

inherit task

RDEPENDS_${PN} = "\
  gnuradio \
  gnuradio-dev \
  gnuradio-examples \
"
