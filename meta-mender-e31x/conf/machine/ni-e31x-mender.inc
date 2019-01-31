MACHINEOVERRIDES =. "ni-e31x-mender:"

# 16GB SD card with some wiggle room for smaller cards
MENDER_STORAGE_TOTAL_SIZE_MB = "15180"

MENDER_FEATURES_ENABLE_append_ni-e31x-mender = " mender-uboot mender-image mender-systemd mender-image-sd"
MENDER_FEATURES_DISABLE_append_ni-e31x-mender = " mender-grub mender-image-uefi"
