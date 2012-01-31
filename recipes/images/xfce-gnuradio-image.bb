#require recipes-images/angstrom/systemd-image.bb
require recipes/images/systemd-openssh-image.bb

IMAGE_INSTALL += " \
  task-usrp-embedded \
  task-sdk-gnuradio-target \
  uhd \
  uhd-dev \
  uhd-examples \
  uhd-tests \
  uhd-e1xx \
  gnuradio \
  gnuradio-dev \
  gnuradio-grc \
  gnuradio-examples \
  qt4-tools \
  qt4-x11-free-dev \
  qt4-mkspecs \
  qwt \
  qwt-dev \
  qwt-examples \
  task-xfce-base \
  task-gnome-xserver-base \
  task-xserver \
  task-gnome-fonts \
  angstrom-gdm-autologin-hack angstrom-gdm-xfce-hack gdm gdm-systemd \
  angstrom-gnome-icon-theme-enable gtk-engine-clearlooks gtk-theme-clearlooks \
  angstrom-clearlooks-theme-enable \
"


#  qmake2 \
#  task-proper-tools \

export IMAGE_BASENAME = "xfce-gnuradio-image"
