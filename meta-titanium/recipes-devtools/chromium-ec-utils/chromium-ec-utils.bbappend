FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_ni-titanium = " \
    git://git@github.com/EttusResearch/chromium-ec-x400.git;branch=titanium;protocol=ssh \
    "

SRCREV_ni-titanium = "e0600dd149a2b90a91ac745b1e6c5d7538d10eac"

LIC_FILES_CHKSUM_ni-titanium = "file://LICENSE;md5=877fdcdaa5a0636e67b479c79335a6d1"
