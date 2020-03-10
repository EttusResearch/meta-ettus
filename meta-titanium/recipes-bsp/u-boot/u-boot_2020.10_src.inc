HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
SECTION = "bootloaders"
DEPENDS += "flex-native bison-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"
PE = "1"


SRC_URI_ni-titanium = "git://git@github.com/u-boot/u-boot.git;branch=master;protocol=ssh \
          "
SRCREV_ni-titanium = "050acee119b3757fee3bd128f55d720fdd9bb890"

S = "${WORKDIR}/git"
