FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-xlnx/${MACHINE}:"

SRC_URI_append_ettus-e200 = " file://fsbl.elf.bz2 \
                              file://uEnv.txt \
                              file://0001-Read-mac-address-from-i2c-EEPROM.patch \
                              file://0002-zynq-Disable-QSPI.patch \
                              file://0003-e200-Reset-USB-phy.patch \
                              file://0004-Also-reset-the-Ethernet-phy.patch \
                              file://0001-board.c-unlock-lock-the-slcr-around-the-code-that-re.patch \
                              file://0001-Revert-zynq-Remove-USB-PHY-out-of-reset-in-board_ini.patch \
                             "

