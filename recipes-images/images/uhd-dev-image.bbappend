
CORE_IMAGE_EXTRA_INSTALL_append = " \
    python3-pip \
    eeprom-tools \
    eeprom-tools-systemd \
    usrp-hwd \
    openocd \
"

MENDER_DATA_PART_DIR_append = "${DEPLOY_DIR_IMAGE}/persist"
