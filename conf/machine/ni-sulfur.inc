require ettus-zynq.inc

MACHINEOVERRIDES = "ni-sulfur:${MACHINE}"

MACHINE_FEATURES = "vfat ethernet usbhost ext2 rtc"

SERIAL_CONSOLE = "115200 ttyPS0"

UBOOT_SUFFIX ?= "img"
UBOOT_ENTRYPOINT = "0000000"
UBOOT_LOADADDRESS = "0000000"
UBOOT_BINARY_ni_sulfur = "u-boot.${UBOOT_SUFFIX}"

IMAGE_BOOT_FILES ?= "boot.bin ${UBOOT_BINARY}"

MACHINE_EXTRA_RRECOMMENDS = "kernel-modules \
                             gpsd gpsd-gpsctl gps-utils \
                            "

KERNEL_CLASSES += "kernel-fitimage"
KERNEL_IMAGETYPE = "fitImage"
KERNEL_DEFCONFIG ?= "ni_sulfur_defconfig"

PREFERRED_VERSION_linux-yocto = "4.12.%"

MACHINE_EXTRA_RRECOMMENDS = " \
                             kernel-modules \
                             kernel-image \
                             linux-firmware-ni-sulfur \
                             linux-firmware-ni-magnesium \
			    "
