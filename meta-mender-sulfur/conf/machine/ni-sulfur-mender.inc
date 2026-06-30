MACHINEOVERRIDES =. "ni-sulfur-mender:"

# 16GB SD card with some wiggle room for smaller cards
MENDER_STORAGE_TOTAL_SIZE_MB = "15180"
MENDER_DATA_PART_SIZE_MB = "128"
MENDER_BOOT_PART_SIZE_MB = "16"
MENDER_STORAGE_DEVICE = "/dev/mmcblk0"

# force a fixed partitioning (Mender default values as of OE sumo release)
MENDER_PARTITIONING_OVERHEAD_KB="32768"
MENDER_PARTITION_ALIGNMENT="8388608"
MENDER_RESERVED_SPACE_BOOTLOADER_DATA="16777216"

MENDER_FEATURES_ENABLE:append:ni-sulfur-mender = " mender-uboot mender-image mender-systemd mender-image-sd"
MENDER_FEATURES_DISABLE:append:ni-sulfur-mender = " mender-grub mender-image-uefi"

IMAGE_INSTALL:append = " mender-migrate-configuration mender-is-mender-update"
PACKAGECONFIG:remove = "split-mender-config"
MENDER_PERSISTENT_CONFIGURATION_VARS = "RootfsPartA RootfsPartB"
# MENDER_ARTIFACT_EXTRA_ARGS:append = " -v 2"

# IMAGE_BOOT_FILES:append = " u-boot.env"

PREFERRED_VERSION_mender ?= "4.0.7"
