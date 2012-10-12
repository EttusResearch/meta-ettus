require recipes/images/console-base-image.bb

DEPENDS += "task-base-extended \
	   "

DISTRO_SSH_DAEMON = "openssh"

IMAGE_INSTALL += " \
  task-base-extended \
  task-proper-tools \
  task-usrp-embedded \
  task-gnuradio \
  i2c-tools \
  ethtool \
"

export IMAGE_BASENAME = "hw-test-image"
