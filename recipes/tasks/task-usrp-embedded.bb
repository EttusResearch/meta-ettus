DESCRIPTION = "Base software to install on USRP Embedded"

PR = "r2"

inherit task

RDEPENDS_${PN} = "\
  kernel-modules \
  oprofile \
  screen \
  task-native-gnuradio-sdk \
  gdb \
  uhd \
  uhd-dev \
  uhd-examples \
  uhd-tests \
  vim-vimrc \
"
