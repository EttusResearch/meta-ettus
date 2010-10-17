# X11 for the USRP Embedded

require usrp-embedded-desktop-image.bb

IMAGE_EXTRA_INSTALL ?= ""

GNURADIO = "\
  gnuradio-srctree \
  gnuradio-srctree-examples \
"

IMAGE_INSTALL += " \
  ${GNURADIO} \
"

