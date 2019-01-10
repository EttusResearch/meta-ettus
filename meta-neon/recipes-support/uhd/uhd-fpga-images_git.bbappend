FILESEXTRAPATHS_prepend_ni-neon := "${THISDIR}/files:"

SRC_URI_append_ni-neon = " http://files.ettus.com/binaries/cache/e3xx/fpga-d0360f7/e3xx_e320_fpga_default-gd0360f7.zip;name=neon-fpga "

SRC_URI[neon-fpga.sha256sum] = "7812dd8e7979792b0adc1b64257474ad91ab4237e93e7b3100eb58c97d72204f"

do_install_append_ni-neon(){
    mkdir -p ${D}/usr/share/uhd/images
    install -m 0644 ${WORKDIR}/usrp_e320_fpga_1G.bit ${D}/usr/share/uhd/images/usrp_e320_fpga_1G.bit
    install -m 0644 ${WORKDIR}/usrp_e320_fpga_XG.bit ${D}/usr/share/uhd/images/usrp_e320_fpga_XG.bit
    install -m 0644 ${WORKDIR}/usrp_e320_fpga_AA.bit ${D}/usr/share/uhd/images/usrp_e320_fpga_AA.bit

    install -m 0644 ${WORKDIR}/usrp_e320_fpga_1G.dts ${D}/usr/share/uhd/images/usrp_e320_fpga_1G.dts
    install -m 0644 ${WORKDIR}/usrp_e320_fpga_XG.dts ${D}/usr/share/uhd/images/usrp_e320_fpga_XG.dts
    install -m 0644 ${WORKDIR}/usrp_e320_fpga_AA.dts ${D}/usr/share/uhd/images/usrp_e320_fpga_AA.dts
}

PACKAGES_append_ni-neon = " \
    ${PN}-neon \
"

FILES_${PN}-neon = " \
    /usr/share/uhd/images/usrp_e320_fpga_1G.bit \
    /usr/share/uhd/images/usrp_e320_fpga_XG.bit \
    /usr/share/uhd/images/usrp_e320_fpga_AA.bit \
    /usr/share/uhd/images/usrp_e320_fpga_1G.dts \
    /usr/share/uhd/images/usrp_e320_fpga_XG.dts \
    /usr/share/uhd/images/usrp_e320_fpga_AA.dts \
"

