require usrp-base-image.bb

DESCRIPTION = "A console-only image with uhd and a development/debug \
environment installed."

CORE_IMAGE_EXTRA_INSTALL += " \
    uhd \
    gnuradio \
    gstreamer \
    "

