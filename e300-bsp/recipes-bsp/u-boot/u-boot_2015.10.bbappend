FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-2015.10:"

SRC_URI_append_ettus-e300 = " \
		 file://0001-ARM-zynq-Fix-location-of-stack-and-malloc-areas.patch \
		 file://0001-zynq-e3xx-Support-for-NI-Ettus-Research-E3xx-SDR.patch \ 
		 file://0002-zynq-e3xx-split-up-in-speedgrades.patch \
		 file://0003-zynq-e3xx-Set-ethernet-mac-address.patch \
		 file://0004-zynq-e3xx-Started-working-on-memtest-broken.patch \
		 file://0001-tools-zynqimage-Add-Xilinx-Zynq-boot-header-generati.patch \
		 file://0002-ARM-zynq-Add-target-for-building-bootable-SPL-image-.patch \
		 file://0001-zynq-e3xx-Move-back-to-stoneage.patch \
		 file://0001-zynq-e3xx-Set-db-mux-pins-depending-on-configuration.patch \
                 file://0001-zynq-e3xx-Set-factory-dtb-otherwise-it-doesn-t-boot.patch \
                 file://0001-zynq-e3xx-Fix-revision-mess.patch \
		 "

SRC_URI_append_ettus-e3xx-sg1 = " \
		 file://fpga-1.bin \
		 "
SRC_URI_append_ettus-e3xx-sg3 = " \
		 file://fpga-3.bin \
		 "

SPL_BINARY = "boot.bin"
UBOOT_SUFFIX = "img"
UBOOT_BINARY = "u-boot.${UBOOT_SUFFIX}"

do_compile_append() {
	ln -sf ${S}/spl/${SPL_BINARY} ${S}/${SPL_BINARY}
}

do_deploy_append_ettus-e3xx-sg1() {
	cp ${WORKDIR}/fpga-1.bin ${DEPLOYDIR}/fpga.bin
}

do_deploy_append_ettus-e3xx-sg3() {
	cp ${WORKDIR}/fpga-3.bin ${DEPLOYDIR}/fpga.bin
}
