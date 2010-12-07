DESCRIPTION = "Base software to install GNU Radio"

inherit task

RDEPENDS_${PN} = "\
  gnuradio \
  gnuradio-examples \
"
