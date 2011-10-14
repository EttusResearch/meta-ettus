require recipes-angstrom/images/systemd-image.bb

IMAGE_INSTALL += " \
  task-base-extended \
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


#  task-proper-tools \

export IMAGE_BASENAME = "console-gnuradio-image"
