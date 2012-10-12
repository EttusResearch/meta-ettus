require recipes/images/console-base-image.bb

DISTRO_SSH_DAEMON = "openssh"

DEPENDS += "task-base-extended \
	   "

IMAGE_INSTALL += " \
  task-base-extended \
  task-proper-tools \
  task-usrp-embedded \
  libosip2-dev \
  ortp-dev \
  asterisk \
"


export IMAGE_BASENAME = "console-openbts-devel-image"
