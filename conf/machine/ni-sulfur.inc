require ettus-zynq.inc

MACHINEOVERRIDES = "ni-sulfur:${MACHINE}"

MACHINE_FEATURES = "vfat ethernet usbhost ext2 wifi"

SERIAL_CONSOLE = "115200 ttyPS0"

UBOOT_BINARY_sulfur = "u-boot.${UBOOT_SUFFIX}"

MACHINE_EXTRA_RRECOMMENDS = "kernel-modules \
                             gpsd gpsd-gpsctl gps-utils \
                            "

KERNEL_CLASSES += "kernel-fitimage"
KERNEL_IMAGETYPE = "fitImage"

PREFERRED_VERSION_linux-yocto = "4.10.%"

MACHINE_EXTRA_RRECOMMENDS = " \
                             kernel-modules \
                             kernel-image \
                             linux-firmware-ni-sulfur \
                             linux-firmware-ni-magnesium \
			    "
