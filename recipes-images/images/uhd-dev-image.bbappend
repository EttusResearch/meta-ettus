
CORE_IMAGE_EXTRA_INSTALL_append = " \
    python3-pip \
    eeprom-hostname-systemd \
    usrp-hwd \
    openocd \
"

MENDER_DATA_PART_DIR_append = "${DEPLOY_DIR_IMAGE}/persist"
