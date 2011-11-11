require recipes-images/angstrom/systemd-image.bb

IMAGE_INSTALL += " \
  task-usrp-embedded \
  task-sdk-gnuradio-target \
  uhd \
  uhd-dev \
  uhd-examples \
  uhd-tests \
  uhd-e1xx \
  gnuradio \
  gnuradio-examples \
"


#  task-base-extended \
#  task-proper-tools \

export IMAGE_BASENAME = "console-gnuradio-image"
