MACHINEOVERRIDES =. "ni-titanium-mender:"

MENDER_FEATURES_ENABLE_append_ni-titanium-mender = " mender-uboot mender-image \
    mender-image-sd mender-systemd mender-client-install"
MENDER_FEATURES_DISABLE_append_ni-titanium-mender = " mender-grub mender-image-uefi"

IMAGE_FSTYPES_remove_ni-titanium-mender = "wic wic.bmap"

PREFERRED_VERSION_pn-mender-client = "2.%"
PREFERRED_VERSION_pn-mender-artifact = "3.%"
PREFERRED_VERSION_pn-mender-artifact-native = "3.%"

IMAGE_INSTALL_append = " mender-client-migrate-configuration"
PACKAGECONFIG_remove = "split-mender-config"
MENDER_PERSISTENT_CONFIGURATION_VARS = "RootfsPartA RootfsPartB"
MENDER_ARTIFACT_EXTRA_ARGS_append = " -v 2"

MENDER_DATA_PART_FSTAB_OPTS ?= "defaults,noatime"
MENDER_BOOT_PART_FSTAB_OPTS ?= "defaults,noatime"
