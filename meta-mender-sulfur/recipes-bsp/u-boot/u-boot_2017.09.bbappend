require u-boot-2017.09-common.inc

# Make this ni-sulfur dependent, since we really don't wanna
# autoconfigure even if we build for ni-sulfur-revX
MENDER_UBOOT_AUTO_CONFIGURE_ni-sulfur = "0"
