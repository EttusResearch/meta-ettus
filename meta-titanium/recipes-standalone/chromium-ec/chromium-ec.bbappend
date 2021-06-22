FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE_ni-titanium-ec = "ni-titanium-ec"
CROS_EC_BOARD_ni-titanium-ec = "titanium"

# Rev E and later
SRC_URI_ni-titanium-ec = "git://github.com/EttusResearch/usrp-firmware.git;branch=titanium"
SRCREV_ni-titanium-ec = "11efcf3e6ac055cc894837e080a5eead26d58f45"

# Rev D
SRC_URI_ni-titanium-ec-rev4 = "git://git@github.com/EttusResearch/chromium-ec.git;branch=titanium-rev4;protocol=ssh"
SRCREV_ni-titanium-ec-rev4 = "0462a8897ba7ad06eed5721cc7fe721b431a66c3"

PATCHTOOL = "git"

LIC_FILES_CHKSUM_ni-titanium-ec = "file://LICENSE;md5=877fdcdaa5a0636e67b479c79335a6d1"

EC_BOARD_REV_ni-titanium-ec-rev4 = "4"
EC_BOARD_REV_ni-titanium-ec-rev5 = "5"

do_compile_ni-titanium-ec() {
    oe_runmake BOARD=${CROS_EC_BOARD} BOARD_REV=${EC_BOARD_REV}
}

DEPENDS_ni-titanium-ec += "zip-native"

FLASH_FILES_LINK_ni-titanium-ec = "scu-flash-files-${MACHINE}"
FLASH_FILES_ni-titanium-ec = "scu-flash-files-${MACHINE}${IMAGE_VERSION_SUFFIX}"
FLASH_FILES[vardepsexclude] = "IMAGE_VERSION_SUFFIX"

do_install_append_ni-titanium-ec() {
  # prepare
  cp ${S}/board/titanium/openocd-flash.cfg ${WORKDIR}/openocd-flash-titanium.cfg
  sed -i "/^add_script_search_dir/d" ${WORKDIR}/openocd-flash-titanium.cfg
  sed -i "s|\$BUILD_DIR/ec\.bin|ec.bin|" ${WORKDIR}/openocd-flash-titanium.cfg
  zip -j ${WORKDIR}/${FLASH_FILES}.zip ${S}/board/titanium/titanium-mcu-jtag.cfg \
      ${WORKDIR}/openocd-flash-titanium.cfg ${B}/build/titanium/ec.bin
}

do_deploy_append_ni-titanium-ec() {
  install -m 0644 ${WORKDIR}/${FLASH_FILES}.zip ${DEPLOYDIR}/${FLASH_FILES}.zip
  ln -sf ${FLASH_FILES}.zip ${DEPLOYDIR}/${FLASH_FILES_LINK}.zip
}
