require recipes/images/console-base-image.bb

DISTRO_SSH_DAEMON = "openssh"

DEPENDS += "task-base-extended \
	   "

IMAGE_INSTALL += " \
  task-base-extended \
  task-proper-tools \
  task-usrp-embedded \
  ti-dsplink \
  ti-dsplink-examples \
"


export IMAGE_BASENAME = "console-e1xx-devel-image"
