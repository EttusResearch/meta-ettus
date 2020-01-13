require conf/machine/ni-zynq.inc

MACHINEOVERRIDES = "ni-e31x:${MACHINE}"

MACHINE_FEATURES = "vfat ethernet usbhost ext2 rtc"

SERIAL_CONSOLES ?= "115200;ttyPS0"
SERIAL_CONSOLES_CHECK = "${SERIAL_CONSOLES}"

UBOOT_SUFFIX_ni-e31x = "img"
UBOOT_ENTRYPOINT_ni-e31x = "0000000"
UBOOT_LOADADDRESS_ni-e31x = "0000000"
UBOOT_BINARY_ni-e31x = "u-boot.${UBOOT_SUFFIX}"
SPL_BINARY_ni-e31x = "spl/boot.bin"

PREFERRED_VERSION_u-boot = "2019.07"

IMAGE_BOOT_FILES ?= "boot.bin ${UBOOT_BINARY}"

KERNEL_CLASSES += "kernel-fitimage"
KERNEL_IMAGETYPE = "fitImage"
KERNEL_DEFCONFIG ?= "multi_v7_defconfig"

PREFERRED_VERSION_linux-yocto = "4.18.%"

MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS = " \
                             kernel-image \
                             kernel-modules \
                            "

MACHINE_EXTRA_RRECOMMENDS = " \
                             eeprom-hostname-systemd \
                             gpsd \
                             gpsd-gpsctl \
                             gpsd-machine-conf \
                             haveged \
                            "

IMAGE_INSTALL_append_ni-e31x = " kernel-image"
