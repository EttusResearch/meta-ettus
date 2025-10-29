#@TYPE: Machine
#@NAME: NI Ettus N3xx machine
#@DESCRIPTION: USRP Networked Series N3xx, see https://www.ettus.com/product-categories/usrp-networked-series/

require conf/machine/ni-zynq.inc

MACHINEOVERRIDES:append = ":ni-sulfur"

MACHINE_FEATURES = "vfat ethernet usbhost ext2 rtc"

EXTRA_IMAGEDEPENDS += "virtual/bootloader"
PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot"
PREFERRED_VERSION_u-boot = "2019.07"

SPL_BINARY = "boot.bin"
UBOOT_SUFFIX = "img"
UBOOT_ENTRYPOINT = "0000000"
UBOOT_LOADADDRESS = "0000000"

# UBOOT_BINARY:ni-sulfur = "u-boot.${UBOOT_SUFFIX}"
# SPL_BINARY:ni-sulfur = "spl/boot.bin"
# IMAGE_BOOT_FILES ?= "boot.bin ${UBOOT_BINARY}"

KERNEL_CLASSES += "kernel-fitimage"
KERNEL_IMAGETYPE = "fitImage"
KERNEL_DEFCONFIG ?= "ni_sulfur_defconfig"
KERNEL_DEVICETREE = "${DTB_FILES}"
FIT_CONF_PREFIX = "conf@ni_"

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

# On non-Mender devices, build "wic.xz" and "wic.bmap"
# On Mender enabled devices build "sdimg.bz2" (instead of "sdimg") and "sdimg.bmap"
IMAGE_FSTYPES += "${@bb.utils.contains('MENDER_FEATURES', 'mender-image-sd', ' sdimg.bz2', ' wic.xz wic.bmap', d)} tar.xz"
IMAGE_FSTYPES:remove = "${@bb.utils.contains('MENDER_FEATURES', 'mender-image-sd', ' sdimg', '', d)}"

WKS_FILE ?= "sdimage-minimal.wks"

MACHINE_EXTRA_RRECOMMENDS = " \
                             haveged \
                             util-linux-lsblk \
                             mpmd-tools \
                             eeprom-hostname-systemd \
                             gpsd-machine-conf \
                             udev-machine-conf \
                            "

# IMAGE_INSTALL:append:ni-sulfur = " kernel-image \
#                                   linux-firmware-ni-sulfur \
#                                   linux-firmware-ni-magnesium \
#                                   linux-firmware-adi-mykonos \
#                                   linux-firmware-ni-rhodium \
#                                   gpsd \
# "

do_image_wic[depends] += " \
    u-boot:do_deploy \
    "

SERIAL_CONSOLES ?= "115200;ttyPS0"
SERIAL_CONSOLES_CHECK = "${SERIAL_CONSOLES}"

