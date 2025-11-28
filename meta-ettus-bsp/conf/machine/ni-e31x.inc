#@TYPE: Machine
#@NAME: NI Ettus E31x machine
#@DESCRIPTION: USRP Embedded Series E31x, see https://www.ettus.com/product-categories/usrp-embedded-series/

require conf/machine/ni-zynq.inc

MACHINEOVERRIDES:append = ":ni-common:ni-e31x"

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

MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "kernel-image kernel-devicetree"

EXTRA_IMAGEDEPENDS += "u-boot"
IMAGE_BOOT_FILES ?= "u-boot.${UBOOT_SUFFIX} ${SPL_BINARY} ${KERNEL_IMAGETYPE}"

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

# IMAGE_INSTALL:append = " \
#                              gpsd \
#                              "

do_image_wic[depends] += " \
    virtual/bootloader:do_deploy \
    "

SERIAL_CONSOLES ?= "115200;ttyPS0"
SERIAL_CONSOLES_CHECK = "${SERIAL_CONSOLES}"
