# console image for USRP Embedded (based on omap3 console image from Gumstix)

inherit image

DEPENDS = "task-base"

IMAGE_EXTRA_INSTALL ?= ""

IMAGE_SPLASH = "psplash-angstrom"

DISTRO_SSH_DAEMON = "openssh"

AUDIO_INSTALL = " \
  alsa-utils \
  alsa-utils-aplay \
  alsa-utils-amixer \
  angstrom-zeroconf-audio \
 "

BASE_INSTALL = " \
  task-base-extended \
 "

FIRMWARE_INSTALL = " \
#  linux-firmware \
#  libertas-sd-firmware \
  rt73-firmware \
  zd1211-firmware \
 "

GLES_INSTALL = " \
#  libgles-omap3 \
 "

TOOLS_INSTALL = " \
  bash \
  bzip2 \
  ckermit \
  devmem2 \
#  dhcp-client \
  dosfstools \
  fbgrab \
  fbset \
  fbset-modes \
  i2c-tools \
  ksymoops \
  mkfs-jffs2 \
  mtd-utils \
  nano \
  ntp ntpdate \
  openssh-misc \
  openssh-scp \
  openssh-ssh \
  omap3-writeprom \
  procps \
  socat \
  strace \
  sudo \
  syslog-ng \
  task-proper-tools \
  u-boot-utils \
 "

USRP_EMBEDDED_INSTALL = " \
  kernel-modules \
  oprofile \
  screen \
  task-native-gnuradio-sdk \
  gdb \
  uhd-srctree \
  uhd-srctree-dev \
"

IMAGE_INSTALL += " \
  ${IMAGE_SPLASH} \
  ${BASE_INSTALL} \
  ${AUDIO_INSTALL} \
  ${FIRMWARE_INSTALL} \
  ${GLES_INSTALL} \
  ${IMAGE_EXTRA_INSTALL} \
  ${TOOLS_INSTALL} \
  ${USRP_EMBEDDED_INSTALL} \
 "

IMAGE_PREPROCESS_COMMAND = "create_etc_timestamp"

#ROOTFS_POSTPROCESS_COMMAND += '${@base_conditional("DISTRO_TYPE", "release", "zap_root_password; ", "",d)}'


