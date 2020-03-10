FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_ni-titanium = " \
    git://git@github.com/EttusResearch/chromium-ec-x400.git;branch=titanium;protocol=ssh \
    "

SRCREV_ni-titanium = "5836c0dc492ec7b6223b898f6255d317842f5909"

LIC_FILES_CHKSUM_ni-titanium = "file://LICENSE;md5=877fdcdaa5a0636e67b479c79335a6d1"
