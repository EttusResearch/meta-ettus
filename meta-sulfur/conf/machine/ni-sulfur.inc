require conf/machine/ni-zynq.inc

MACHINEOVERRIDES = "ni-sulfur:${MACHINE}"

MACHINE_FEATURES = "vfat ethernet usbhost ext2 rtc"

SERIAL_CONSOLES ?= "115200;ttyPS0"
SERIAL_CONSOLES_CHECK = "${SERIAL_CONSOLES}"

UBOOT_SUFFIX_ni-sulfur = "img"
UBOOT_ENTRYPOINT = "0000000"
UBOOT_LOADADDRESS = "0000000"
UBOOT_BINARY_ni-sulfur = "u-boot.${UBOOT_SUFFIX}"
SPL_BINARY_ni-sulfur = "spl/boot.bin"

IMAGE_BOOT_FILES ?= "boot.bin ${UBOOT_BINARY}"

KERNEL_CLASSES += "kernel-fitimage"
KERNEL_IMAGETYPE = "fitImage"
KERNEL_DEFCONFIG ?= "ni_sulfur_defconfig"

PREFERRED_VERSION_linux-yocto = "4.18.%"

MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS = " \
                             kernel-image \
                             kernel-modules \
                             linux-firmware-ni-sulfur \
                             linux-firmware-ni-magnesium \
                             linux-firmware-adi-mykonos \
                             linux-firmware-ni-rhodium \
"

MACHINE_EXTRA_RRECOMMENDS = " \
                             mpmd-tools \
                             eeprom-hostname-systemd \
                             gpsd \
                             gpsd-gpsctl \
                             gpsd-machine-conf \
                            "

IMAGE_INSTALL_append_ni-sulfur = " kernel-image"

PREFERRED_VERSION_u-boot = "2018.07"
