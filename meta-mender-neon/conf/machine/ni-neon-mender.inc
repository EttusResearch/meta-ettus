MACHINEOVERRIDES =. "ni-neon-mender:"

# Stay within 16GB of SD Card
MENDER_STORAGE_TOTAL_SIZE_MB ?= "15180"
MENDER_DATA_PART_SIZE_MB ?= "11196"
MENDER_BOOT_PART_SIZE_MB ?= "16"
MENDER_STORAGE_DEVICE = "/dev/mmcblk0"

# force a fixed partitioning (Mender default values as of OE sumo release)
MENDER_PARTITIONING_OVERHEAD_KB ?= "32768"
MENDER_PARTITION_ALIGNMENT ?= "8388608"
MENDER_RESERVED_SPACE_BOOTLOADER_DATA ?= "16777216"

MENDER_FEATURES_ENABLE_append_ni-neon-mender = " mender-uboot mender-image mender-systemd mender-image-sd"
MENDER_FEATURES_DISABLE_append_ni-neon-mender = " mender-grub mender-image-uefi"

PREFERRED_VERSION_pn-mender-client = "2.%"
PREFERRED_VERSION_pn-mender-artifact = "3.%"
PREFERRED_VERSION_pn-mender-artifact-native = "3.%"

IMAGE_INSTALL_append = " mender-client-migrate-configuration"
PACKAGECONFIG_remove = "split-mender-config"
MENDER_PERSISTENT_CONFIGURATION_VARS = "RootfsPartA RootfsPartB"
MENDER_ARTIFACT_EXTRA_ARGS_append = " -v 2"
