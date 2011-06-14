DESCRIPTION = "Base software to install on USRP Embedded"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r5"

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
  uhd-e1xx \
  vim-vimrc \
"
