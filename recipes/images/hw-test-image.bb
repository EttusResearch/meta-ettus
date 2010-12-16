require recipes/images/console-base-image.bb

DEPENDS += "task-base-extended \
	   "

IMAGE_INSTALL += " \
  task-base-extended \
  task-proper-tools \
  task-usrp-embedded \
  task-gnuradio \
  i2c-tools \
  ethtool \
"

export IMAGE_BASENAME = "usrp-embedded-hw-test-image"
