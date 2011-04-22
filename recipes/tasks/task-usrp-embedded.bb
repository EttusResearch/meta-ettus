DESCRIPTION = "Base software to install on USRP Embedded"

PR = "r3"

inherit task

RDEPENDS_${PN} = "\
  kernel-modules \
  oprofile \
  screen \
  htop \
  powertop \
  task-native-gnuradio-sdk \
  python-lxml \
  python-subprocess \
  gdb \
  uhd \
  uhd-dev \
  uhd-examples \
  uhd-tests \
  vim-vimrc \
"
