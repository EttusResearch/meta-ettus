# X11 for the USRP Embedded

require usrp-embedded-console-image.bb

IMAGE_EXTRA_INSTALL ?= ""

#IMAGE_FEATURES += "dbg"

GNURADIO = "\
  gnuradio-srctree \
  gnuradio-srctree-examples \
"

IMAGE_INSTALL += " \
  ${GNURADIO} \
"

