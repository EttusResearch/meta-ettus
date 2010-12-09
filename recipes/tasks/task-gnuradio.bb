DESCRIPTION = "Base software to install GNU Radio"

PR = "r2"

inherit task

RDEPENDS_${PN} = "\
  gnuradio \
  gnuradio-examples \
"
