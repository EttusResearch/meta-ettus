FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-${PV}:"

SRC_URI_append_ettus-e300 = " \
                 file://0001-e3xx-Add-platform-definition-files-for-e3xx.patch \
                 file://0002-e3xx-Add-device-tree-files-for-Ettus-E3xx-series.patch \
                 file://0003-e3xx-Add-support-for-the-Ettus-Research-E3XX-family-.patch \
                 file://0001-Add-support-for-mender.io-software-update.patch \
		 "

SRC_URI_append_ni-sulfur = " \
    file://sulfur/0001-i2c-muxes-pca954x-Add-support-for-GPIO-reset-line.patch \
    file://sulfur/0001-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
    file://sulfur/0002-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
    file://sulfur/0003-ni-sulfur-rev3-Added-swsync-feature.patch \
    file://sulfur/0004-ni-sulfur-rev3-Add-autoboot-support.patch \
    file://sulfur/0005-ni-sulfur-rev3-Fix-defconfig-for-2017.09.patch \
    file://sulfur/0010-i2c-mux-pca954x-Add-addtitional-compatible-string-fo.patch \
    file://sulfur/0012-board-ni-zynq-Add-parsing-code-for-sulfur.patch \
    file://sulfur/0013-misc-cros_ec-Add-trivial-support-for-software-sync.patch \
    "

SPL_BINARY = "spl/boot.bin"

HAS_PS7INIT = " \
                zynq_e3xx_1_defconfig \
                zynq_e3xx_3_defconfig \
                ni_sulfur_rev2_defconfig \
                ni_sulfur_rev3_defconfig \
              "

SRC_URI_append_ettus-e3xx-sg1 = " \
		 file://fpga-1.bin \
		 "
SRC_URI_append_ettus-e3xx-sg3 = " \
		 file://fpga-3.bin \
		 "



do_deploy_append_ettus-e3xx-sg1() {
	cp ${WORKDIR}/fpga-1.bin ${DEPLOYDIR}/fpga.bin
}

do_deploy_append_ettus-e3xx-sg3() {
	cp ${WORKDIR}/fpga-3.bin ${DEPLOYDIR}/fpga.bin
}

