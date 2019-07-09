# fix version to 4.18.27 because in newer versions
# there are issues with the communication to chromium-ec on the STM32
SRCREV_machine = "62f0a3acffffd555f68ed97d5e4faade2b28f3c0"
SRCREV_meta = "9e348b6f9db185cb60a34d18fd14a18b5def2c31"
LINUX_VERSION = "4.18.27"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-4.18:"

SRC_URI_append = " \
                   file://core.scc \
                   file://core.cfg \
                   file://usrp.scc \
                   file://usrp.cfg \
                 "
