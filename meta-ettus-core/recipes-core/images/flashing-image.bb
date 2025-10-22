SUMMARY = "minimal image which provides bmaptool for flashing"
LICENSE = "MIT"

inherit core-image

IMAGE_FEATURES += "debug-tweaks"
IMAGE_INSTALL += "bmaptool util-linux-lsblk gzip xz"
