MACHINEOVERRIDES =. "ni-titanium-mender:"

MENDER_FEATURES_ENABLE_append_ni-titanium-mender = " mender-uboot mender-image \
    mender-image-sd mender-systemd mender-client-install"
MENDER_FEATURES_DISABLE_append_ni-titanium-mender = " mender-grub mender-image-uefi"

IMAGE_FSTYPES_remove_ni-titanium-mender = "wic wic.bmap"
