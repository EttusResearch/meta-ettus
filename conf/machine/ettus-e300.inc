#@TYPE: Machine
#@Name: Ettus Research E3XX.
#@DESCRIPTION: Machine configuration for the Ettus Research E3XX Software Radio.

require ettus-zynq.inc

MACHINEOVERRIDES = "ettus-e300:${MACHINE}"

MACHINE_FEATURES = "vfat ethernet alsa usbhost bluetooth ext2 wifi"

SERIAL_CONSOLE = "115200 ttyPS0"

UBOOT_BINARY_ettus-e300 = "u-boot.${UBOOT_SUFFIX}"

MACHINE_EXTRA_RRECOMMENDS = "kernel-modules acpid rtimulib rtimulib-conf \
                             e3xx-udev-rules \
                             gpsd gps-config gpsd-gpsctl gps-utils \
                            "

IMAGE_BOOT_FILES += "fpga.bin"
