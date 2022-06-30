DESCRIPTION = "Small image for use by manufacturing test. Includes tools for flashing eMMC and SD cards"
PACKAGE_INSTALL = "packagegroup-core-boot bmap-tools util-linux-lsblk"

IMAGE_FEATURES = "debug-tweaks"

export IMAGE_BASENAME = "${MLPREFIX}manufacturing-image"
IMAGE_LINGUAS = ""

INITRAMFS_MAXSIZE = "2000000"

LICENSE = "MIT"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
inherit core-image

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

COMPATIBLE_HOST = "aarch64-oe-linux|arm-oe-linux-gnueabi"

# Remove this to reduce the end image size
BAD_RECOMMENDATIONS = "udev-hwdb"

ROOTFS_POSTPROCESS_COMMAND_remove = "mender_update_fstab_file;"
