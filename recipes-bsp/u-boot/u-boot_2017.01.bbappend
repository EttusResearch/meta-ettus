FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-${PV}:"

SRC_URI_append_ettus-e300 = " \
                 file://0001-e3xx-Add-platform-definition-files-for-e3xx.patch \
                 file://0002-e3xx-Add-device-tree-files-for-Ettus-E3xx-series.patch \
                 file://0003-e3xx-Add-support-for-the-Ettus-Research-E3XX-family-.patch \
                 file://0001-Add-support-for-mender.io-software-update.patch \
		 "

SRC_URI_append_ni-sulfur = " \
                 file://sulfur/0001-cros_ec-i2c-Group-i2c-write-read-into-single-transac.patch \
                 file://sulfur/0002-cros_ec-i2c-Add-support-for-version-3-of-the-EC-prot.patch \
                 file://sulfur/0003-i2c-cdns-Add-additional-compatible-string-for-r1p14-.patch \
                 file://sulfur/0004-i2c-i2c-cdns-Detect-unsupported-sequences-for-rev-1..patch \
                 file://sulfur/0005-i2c-i2c-cdns-Reorder-timeout-loop-for-interrupt-wait.patch \
                 file://sulfur/0006-i2c-i2c-cdns-No-need-for-dedicated-probe-function.patch \
                 file://sulfur/0007-i2c-mux-Allow-muxes-to-work-as-children-of-i2c-bus-w.patch \
                 file://sulfur/0008-i2c-i2c-cdns-Implement-workaround-for-hold-quirk-of-.patch \
                 file://sulfur/0009-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
                 file://sulfur/0010-ni-zynq-Add-support-for-NI-Ettus-Research-Project-Su.patch \
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

