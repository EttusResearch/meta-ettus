require recipes/images/console-base-image.bb

DEPENDS += "task-base-extended \
	   "

IMAGE_INSTALL += " \
  task-base-extended \
  task-proper-tools \
  task-usrp-embedded \
  task-gnuradio \
"


export IMAGE_BASENAME = "usrp-embedded-console-image"
