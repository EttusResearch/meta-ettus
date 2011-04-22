require recipes/images/console-base-image.bb

DISTRO_SSH_DAEMON = "openssh"

DEPENDS += "task-base-extended \
	   "

IMAGE_INSTALL += " \
  task-base-extended \
  task-proper-tools \
  task-usrp-embedded \
  task-gnuradio \
"


export IMAGE_BASENAME = "console-gnuradio-image"
