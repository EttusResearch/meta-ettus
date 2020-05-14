MACHINEOVERRIDES =. "ni-e31x-mender:"

# 8GB SD card with some wiggle room for smaller cards
MENDER_STORAGE_TOTAL_SIZE_MB = "7372"
MENDER_DATA_PART_SIZE_MB = "2000"
MENDER_BOOT_PART_SIZE_MB = "16"
MENDER_STORAGE_DEVICE = "/dev/mmcblk0"

MENDER_FEATURES_ENABLE_append_ni-e31x-mender = " mender-uboot mender-image mender-systemd mender-image-sd"
MENDER_FEATURES_DISABLE_append_ni-e31x-mender = " mender-grub mender-image-uefi"

PREFERRED_VERSION_pn-mender-client = "2.%"
PREFERRED_VERSION_pn-mender-artifact = "3.%"
PREFERRED_VERSION_pn-mender-artifact-native = "3.%"

IMAGE_INSTALL_append = " mender-client-migrate-configuration"
PACKAGECONFIG_remove = "split-mender-config"
MENDER_PERSISTENT_CONFIGURATION_VARS = "RootfsPartA RootfsPartB"
MENDER_ARTIFACT_EXTRA_ARGS_append = " -v 2"
