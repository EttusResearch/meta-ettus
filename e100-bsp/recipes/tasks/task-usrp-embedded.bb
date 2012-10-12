DESCRIPTION = "Base software to install on USRP Embedded"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r6"

inherit task

RDEPENDS_${PN} = "\
  kernel-modules \
  oprofile \
  screen \
  htop \
  powertop \
  python-lxml \
  python-modules \
  gdb \
  vim-vimrc \
"
