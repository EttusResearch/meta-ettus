require u-boot-2018.01-common.inc

# Make this ni-e31x-mender dependent, since we really don't wanna
# autoconfigure even if we build for ni-sulfur-revX
MENDER_UBOOT_AUTO_CONFIGURE_ni-e31x-mender = "0"
