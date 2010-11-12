DESCRIPTION = "Base software to install on USRP Embedded"

inherit task

RDEPENDS_${PN} = "\
  kernel-modules \
  oprofile \
  screen \
  task-native-gnuradio-sdk \
  gdb \
  uhd-srctree \
  uhd-srctree-dev \
  uhd-srctree-examples \
  uhd-srctree-tests \
"
