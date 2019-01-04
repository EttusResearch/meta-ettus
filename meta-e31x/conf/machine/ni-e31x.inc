require conf/machine/ni-zynq.inc

MACHINEOVERRIDES = "ni-e31x:${MACHINE}"

MACHINE_FEATURES = "vfat ethernet usbhost ext2 rtc"

SERIAL_CONSOLE = "115200 ttyPS0"

UBOOT_SUFFIX ?= "img"
UBOOT_ENTRYPOINT = "0000000"
UBOOT_LOADADDRESS = "0000000"
UBOOT_BINARY_ni-e31x = "u-boot.${UBOOT_SUFFIX}"

IMAGE_BOOT_FILES ?= "boot.bin ${UBOOT_BINARY}"

KERNEL_CLASSES += "kernel-fitimage"
KERNEL_IMAGETYPE = "fitImage"
KERNEL_DEFCONFIG ?= "multi_v7_defconfig"

PREFERRED_VERSION_linux-yocto = "4.18.%"

MACHINE_EXTRA_RRECOMMENDS = " \
                             kernel-modules \
                             gpsd \
                             gpsd-gpsctl \
                             gps-utils \
                             gpsd-machine-conf \
                             kernel-image \
                            "

IMAGE_INSTALL_append_ni-e31x = " kernel-image"
