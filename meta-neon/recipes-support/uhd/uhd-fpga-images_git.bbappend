FILESEXTRAPATHS_prepend_ni-neon := "${THISDIR}/files:"

SRC_URI_append_ni-neon = " http://files.ettus.com/binaries/cache/e3xx/fpga-10c27fb5/e3xx_e320_fpga_default-g10c27fb5.zip;name=neon-fpga \
                         "

SRC_URI[neon-fpga.sha256sum] = "aa0338b911cf814cbefa67a794d992706afc16f3f2e7ccbed921f7c75900d6fb"
SRC_URI[neon-fpga-aurora.sha256sum] = "73a3851e890df827ec1b809e34cea49cf973ba225ef9852416c77237f18f016c"

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

