HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
SECTION = "bootloaders"
DEPENDS += "flex-native bison-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"
PE = "1"


SRC_URI_ni-titanium = "git://git@github.com/EttusResearch/u-boot.git;branch=titanium-2020.10-mender;protocol=ssh \
          "
SRCREV_ni-titanium = "a74c6da252de00f91490de54296f4e7ec275fe06"

S = "${WORKDIR}/git"
