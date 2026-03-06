require conf/machine/ni-zynqmp.inc
require conf/machine/include/arm/armv8a/tune-cortexa53.inc

MACHINEOVERRIDES = "zynqmp:ni-common:ni-titanium:${MACHINE}"
MACHINE_FEATURES = "rtc ethernet ext2 ext3 vfat usbhost"

PREFERRED_PROVIDER_virtual/bootloader = "u-boot"

UBOOT_SUFFIX:zynqmp ?= "itb"
UBOOT_BINARY ?= "u-boot.${UBOOT_SUFFIX}"
UBOOT_ELF:aarch64 ?= "u-boot.elf"

UBOOT_LOADADDRESS = "0x200000"
UBOOT_ENTRYPOINT = "0x200000"
UBOOT_DTB_LOADADDRESS = "0x70000"
UBOOT_DTBO_LOADADDRESS = "0x7C000"

SPL_BINARY ?= "spl/boot.bin"
PREFERRED_VERSION_u-boot ?= "2026.01%"

PREFERRED_PROVIDER_virtual/arm-trusted-firmware = "arm-trusted-firmware"
# TODO: check why newer versions of arm-trusted-firmware do not work:
# with newer versions than 2.6-xilinx-v2022.2+git, U-Boot SPL (boot.bin)
# is loaded but U-Boot (u-boot.itb) is not
PREFERRED_VERSION_arm-trusted-firmware = "2.6-xilinx-v2022.2+git"
# PREFERRED_VERSION_arm-trusted-firmware = "2.8-xilinx-v2023.1+git"

SERIAL_CONSOLES ?= "115200;ttyPS0"
SERIAL_CONSOLES_CHECK ?= "${SERIAL_CONSOLES}"

KERNEL_DEVICETREE:ni-titanium ?= "\
	ni/x410-rev2.dtb \
	ni/x410-rev3.dtb \
	ni/x410-rev4.dtb \
	ni/x410-rev5.dtb \
	ni/x410-rev6.dtb \
	ni/x410-rev7.dtb \
	ni/x4xx-db0-0x4001-rev1.dtbo \
	ni/x4xx-db1-0x4001-rev1.dtbo \
	ni/x4xx-dioaux-0x4003-rev1.dtbo \
	ni/x4xx-clkaux-0x4004-rev1.dtbo \
	ni/x4xx-clkaux-0x4005-rev1.dtbo \
	ni/x4xx-clkaux-0x4004-rev2.dtbo \
	ni/x4xx-clkaux-0x4005-rev2.dtbo \
	ni/x4xx-db0-0x4006-rev1.dtbo \
	ni/x4xx-db1-0x4006-rev1.dtbo \
	ni/x4xx-db0-db-flash.dtbo \
	ni/x4xx-db1-db-flash.dtbo \
"
FIT_CONF_PREFIX = "conf@ni_"

IMAGE_BOOT_FILES ?= "boot.bin ${UBOOT_BINARY} ${KERNEL_IMAGETYPE}"
PMU_FIRMWARE_DEPLOY_DIR ?= "${TOPDIR}/tmp-xilinx/deploy/images/zynqmp-pmu"
PMU_FIRMWARE_IMAGE_NAME ?= "pmu-firmware-zynqmp-pmu"

KERNEL_CLASSES += "kernel-fitimage"
KERNEL_IMAGETYPE = "fitImage"
INITRAMFS_IMAGE = "manufacturing-image"
# INITRAMFS_IMAGE_BUNDLE = "1"

MACHINE_ESSENTIAL_EXTRA_RDEPENDS += " \
                             kernel-image \
                             kernel-devicetree \
                             watchdog \
                             usrp-firmware \
                            "

MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS = " \
                             kernel-image \
                             kernel-devicetree \
                             kernel-modules \
                             usrp-firmware \
          "

MACHINE_EXTRA_RRECOMMENDS = " \
                             eeprom-hostname-systemd \
                             gpsd-machine-conf \
                             haveged \
                             ledctrl \
			     mmc-utils \
			     uhd-cpld-images \
                             udev-machine-conf \
          "

do_image_wic[depends] += " \
    u-boot:do_deploy \
    "

# On non-Mender devices, build "wic.xz" and "wic.bmap"
# On Mender enabled devices build "sdimg.bz2" (instead of "sdimg") and "sdimg.bmap"
IMAGE_FSTYPES += "${@bb.utils.contains('MENDER_FEATURES', 'mender-image-sd', ' sdimg.bz2', ' wic.bz2 wic.bmap', d)} tar.xz"
IMAGE_FSTYPES:remove = "${@bb.utils.contains('MENDER_FEATURES', 'mender-image-sd', ' sdimg', '', d)}"
