#@TYPE: Machine
#@NAME: NI Ettus E320 machine
#@DESCRIPTION: USRP Embedded Series E320, see https://www.ettus.com/product-categories/usrp-embedded-series/

require conf/machine/ni-zynq.inc

MACHINEOVERRIDES:append = ":ni-neon"

MACHINE_FEATURES = "vfat ethernet usbhost ext2 rtc"

EXTRA_IMAGEDEPENDS += "virtual/bootloader"
PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot"
PREFERRED_VERSION_u-boot = "2019.07"

SPL_BINARY = "boot.bin"
UBOOT_SUFFIX = "img"
UBOOT_ENTRYPOINT = "0000000"
UBOOT_LOADADDRESS = "0000000"

KERNEL_CLASSES += "kernel-fitimage"
KERNEL_IMAGETYPE = "fitImage"
KERNEL_DEFCONFIG ?= "multi_v7_defconfig"
KERNEL_DEVICETREE = "${DTB_FILES}"
FIT_CONF_PREFIX = "conf@"

INITRAMFS_IMAGE = "manufacturing-image"
# INITRAMFS_IMAGE_BUNDLE = "1"

PREFERRED_VERSION_linux-yocto = "5.2.%"

MACHINE_ESSENTIAL_EXTRA_RDEPENDS += " \
                             kernel-image \
                             kernel-devicetree \
                             watchdog \
                             usrp-firmware \
                            "

EXTRA_IMAGEDEPENDS += "u-boot"
IMAGE_BOOT_FILES ?= "u-boot.${UBOOT_SUFFIX} ${SPL_BINARY} ${KERNEL_IMAGETYPE} ${KERNEL_DEVICETREE}"
IMAGE_FSTYPES += "${@bb.utils.contains('MENDER_FEATURES', 'mender-image-sd', '', ' wic.xz wic.bmap', d)} tar.xz"
WKS_FILE ?= "sdimage-minimal.wks"

MACHINE_EXTRA_RRECOMMENDS = " \
                             haveged \
                             util-linux-lsblk \
                             mpmd-tools \
                             eeprom-hostname-systemd \
                             gpsd-machine-conf \
                            "

# IMAGE_INSTALL:append:ni-neon = " kernel-image \
#                                 linux-firmware-ni-neon \
#                                 gpsd \
#                                "

do_image_wic[depends] += " \
    u-boot:do_deploy \
    "

SERIAL_CONSOLES ?= "115200;ttyPS0"
SERIAL_CONSOLES_CHECK = "${SERIAL_CONSOLES}"

