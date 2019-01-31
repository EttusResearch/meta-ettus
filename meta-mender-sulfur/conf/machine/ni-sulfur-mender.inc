MACHINEOVERRIDES =. "ni-sulfur-mender:"

# 16GB SD card with some wiggle room for smaller cards
MENDER_STORAGE_TOTAL_SIZE_MB = "15180"
MENDER_STORAGE_DEVICE = "/dev/mmcblk0"

MENDER_FEATURES_ENABLE_append_ni-sulfur-mender = " mender-uboot mender-image mender-systemd mender-image-sd"
MENDER_FEATURES_DISABLE_append_ni-sulfur-mender = " mender-grub mender-image-uefi"
