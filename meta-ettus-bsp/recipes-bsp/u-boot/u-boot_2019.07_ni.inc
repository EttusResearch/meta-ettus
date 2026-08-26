FILESEXTRAPATHS:prepend:ni-e31x := "${THISDIR}/files/ni-e31x:"
FILESEXTRAPATHS:prepend:ni-neon := "${THISDIR}/files/ni-neon:"
FILESEXTRAPATHS:prepend:ni-sulfur := "${THISDIR}/files/ni-sulfur:"

SRC_URI:prepend:ni-e31x = " \
    file://0001-ni-zynq-Add-support-for-NI-E31x-SG1-SG3-boards.patch \
    file://0002-configs-ni_e31x_sg-1-3-Added-network-commands-dhcp-t.patch \
    file://0003-configs-ni_e31x_sg-1-3-add-CONFIG_USE_BOOTCOMMAND.patch \
    file://0004-configs-ni_e31x-Add-tftp-port-selection.patch \
    "

SRC_URI:prepend:ni-neon-rev1 = " \
    file://0001-misc-cros_ec-Add-trivial-support-for-software-sync.patch \
    file://0001-ni-zynq-Add-support-for-NI-Project-Neon-Rev1-SDR.patch \
    file://0002-ni-zynq-Added-network-commands-dhcp-tftpboot.patch \
    file://0003-ni-zynq-set-bootdelay-to-3-seconds.patch \
    file://0004-ni-zynq-Add-tftp-port-selection.patch \
"

SRC_URI:prepend:ni-neon-rev2 = " \
    file://0001-misc-cros_ec-Add-trivial-support-for-software-sync.patch \
    file://0001-ni-zynq-Add-support-for-NI-Project-Neon-Rev2-SDR.patch \
    file://0002-ni-zynq-Added-network-commands-dhcp-tftpboot.patch \
    file://0003-ni-zynq-set-bootdelay-to-3-seconds.patch \
    file://0004-ni-zynq-Add-tftp-port-selection.patch \
"

SRC_URI:prepend:ni-sulfur = " \
    file://0001-misc-cros_ec-Add-trivial-support-for-software-sync.patch \
    file://0001-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
    file://0002-configs-ni_sulfur_rev3-Add-tftp-port-selection.patch \
    file://0003-board-ni-zynq-retry-N3xx-motherboard-EEPROM-probe.patch \
    "

do_compile:append:ni-e31x() {
    mv ${B}/spl/${SPL_BINARY} ${B}/${SPL_BINARY}
}

do_compile:append:ni-neon() {
    mv ${B}/spl/${SPL_BINARY} ${B}/${SPL_BINARY}
}

do_compile:append:ni-sulfur() {
    mv ${B}/spl/${SPL_BINARY} ${B}/${SPL_BINARY}
}
