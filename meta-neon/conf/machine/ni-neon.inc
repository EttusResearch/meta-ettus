require conf/machine/ni-zynq.inc

MACHINEOVERRIDES = "ni-neon:${MACHINE}"

MACHINE_FEATURES = "vfat ethernet usbhost ext2 rtc"

SERIAL_CONSOLES ?= "115200;ttyPS0"
SERIAL_CONSOLES_CHECK = "${SERIAL_CONSOLES}"

UBOOT_SUFFIX ?= "img"
UBOOT_ENTRYPOINT = "0000000"
UBOOT_LOADADDRESS = "0000000"
UBOOT_BINARY_ni-neon = "u-boot.${UBOOT_SUFFIX}"
SPL_BINARY_ni-neon = "spl/boot.bin"

IMAGE_BOOT_FILES ?= "boot.bin ${UBOOT_BINARY}"

KERNEL_CLASSES += "kernel-fitimage"
KERNEL_IMAGETYPE = "fitImage"
KERNEL_DEFCONFIG ?= "ni_neon_defconfig"

PREFERRED_VERSION_linux-yocto = "4.18.%"

MACHINE_EXTRA_RRECOMMENDS = " \
                             kernel-modules \
                             gpsd \
                             gpsd-gpsctl \
                             gps-utils \
                             gpsd-machine-conf \
                             kernel-image \
                             linux-firmware-ni-neon \
                            "

IMAGE_INSTALL_append_ni-neon = " kernel-image"
