require recipes-images/angstrom/systemd-image.bb

IMAGE_INSTALL += " \
  task-usrp-embedded \
  task-sdk-gnuradio-target \
  uhd \
  uhd-dev \
  uhd-examples \
  uhd-tests \
  uhd-e1xx \
  task-gnome \
  task-gnome-apps \
  task-gnome-themes \
  task-gnome-xserver-base \
  task-xserver \
  task-gnome-fonts \
  qmake2 \
  qt4-tools \
  qt4-x11-free-dev \
  qt4-mkspecs \
  qwt \
  qwt-dev \
  qwt-examples \
  less \
"


#  task-base-extended \
#  task-proper-tools \

export IMAGE_BASENAME = "gnome-qt-image"
