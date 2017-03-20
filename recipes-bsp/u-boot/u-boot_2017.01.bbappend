FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-${PV}:"

SRC_URI_append_ettus-e300 = " \
                 file://0001-e3xx-Add-platform-definition-files-for-e3xx.patch \
                 file://0002-e3xx-Add-device-tree-files-for-Ettus-E3xx-series.patch \
                 file://0003-e3xx-Add-support-for-the-Ettus-Research-E3XX-family-.patch \
                 file://0001-Add-support-for-mender.io-software-update.patch \
		 "

SRC_URI_append_sulfur = " \
                 file://0001-zynq-Move-ENV-location-selection-from-zynq-common.h-.patch \
                 file://0002-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
                 file://0003-Updates-to-Ettus-Sulfur-for-use-with-mender.patch \
                 file://0004-sulfur-Use-fit-image-from-root-file-system-for-booti.patch \
                 file://0001-zynq-spi-Honour-the-activation-deactivation-delay.patch \
                 "

SPL_BINARY = "spl/boot.bin"

HAS_PS7INIT = " \
                zynq_e3xx_1_defconfig \
                zynq_e3xx_3_defconfig \
                ni_sulfur_rev2_defconfig \
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

