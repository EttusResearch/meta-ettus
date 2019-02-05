FILESEXTRAPATHS_prepend_ni-sulfur := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur  = " http://files.ettus.com/binaries/cache/n3xx/fpga-1107862/n3xx_n310_fpga_default-g1107862.zip;name=sulfur-fpga \
             http://files.ettus.com/binaries/cache/n3xx/fpga-1107862/n3xx_n300_fpga_default-g1107862.zip;name=phosphorus-fpga \
             http://files.ettus.com/binaries/cache/n3xx/fpga-1107862/n3xx_n310_fpga_aurora-g1107862.zip;name=sulfur-fpga-aurora \
             http://files.ettus.com/binaries/cache/n3xx/fpga-1107862/n3xx_n300_fpga_aurora-g1107862.zip;name=phosphorus-fpga-aurora \
             http://files.ettus.com/binaries/cache/n3xx/fpga-c41506b/n3xx_n320_fpga_default-gc41506b.zip;name=rhodium-fpga \
           "

SRC_URI[sulfur-fpga.sha256sum] = "fc80462f2e144d9745b0b480aa513f426e48df46ad18dc85cbb8fdb3cb162355"
SRC_URI[sulfur-fpga-aurora.sha256sum] = "3926d6b247a8f931809460d3957cec51f8407cd3f7aea6f4f3b91d1bbb427c7d"

SRC_URI[phosphorus-fpga.sha256sum] = "1e7ae1429825811531149f87f82dfcbc06cf63e1fc3752517edf104950406c36"
SRC_URI[phosphorus-fpga-aurora.sha256sum] = "e34e9343572adfba905433a1570cb394fe45207d442268d0fa400c3406253530"

SRC_URI[rhodium-fpga.sha256sum] = "af6b4fcf28caee9de96e865f705541657d04a8abf2cf383dacf1640e1bbfaafb"

do_install_append_ni-sulfur(){
    mkdir -p ${D}/usr/share/uhd/images
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_AQ.bit ${D}/usr/share/uhd/images/usrp_n320_fpga_AQ.bit
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_XQ.bit ${D}/usr/share/uhd/images/usrp_n320_fpga_XQ.bit
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_HG.bit ${D}/usr/share/uhd/images/usrp_n320_fpga_HG.bit
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_XG.bit ${D}/usr/share/uhd/images/usrp_n320_fpga_XG.bit
    install -m 0644 ${WORKDIR}/usrp_n320_fgpa_WX.bit ${D}/usr/share/uhd/images/usrp_n320_fpga_WX.bit
    install -m 0644 ${WORKDIR}/usrp_n310_fpga_HG.bit ${D}/usr/share/uhd/images/usrp_n310_fpga_HG.bit
    install -m 0644 ${WORKDIR}/usrp_n310_fpga_XG.bit ${D}/usr/share/uhd/images/usrp_n310_fpga_XG.bit
    install -m 0644 ${WORKDIR}/usrp_n310_fpga_AA.bit ${D}/usr/share/uhd/images/usrp_n310_fpga_AA.bit
    install -m 0644 ${WORKDIR}/usrp_n310_fpga_WX.bit ${D}/usr/share/uhd/images/usrp_n310_fpga_WX.bit
    install -m 0644 ${WORKDIR}/usrp_n300_fpga_HG.bit ${D}/usr/share/uhd/images/usrp_n300_fpga_HG.bit
    install -m 0644 ${WORKDIR}/usrp_n300_fpga_XG.bit ${D}/usr/share/uhd/images/usrp_n300_fpga_XG.bit
    install -m 0644 ${WORKDIR}/usrp_n300_fpga_AA.bit ${D}/usr/share/uhd/images/usrp_n300_fpga_AA.bit
    install -m 0644 ${WORKDIR}/usrp_n300_fpga_WX.bit ${D}/usr/share/uhd/images/usrp_n300_fpga_WX.bit

    install -m 0644 ${WORKDIR}/usrp_n320_fpga_AQ.dts ${D}/usr/share/uhd/images/usrp_n320_fpga_AQ.dts
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_XQ.dts ${D}/usr/share/uhd/images/usrp_n320_fpga_XQ.dts
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_HG.dts ${D}/usr/share/uhd/images/usrp_n320_fpga_HG.dts
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_XG.dts ${D}/usr/share/uhd/images/usrp_n320_fpga_XG.dts
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_WX.dts ${D}/usr/share/uhd/images/usrp_n320_fpga_WX.dts
    install -m 0644 ${WORKDIR}/usrp_n310_fpga_HG.dts ${D}/usr/share/uhd/images/usrp_n310_fpga_HG.dts
    install -m 0644 ${WORKDIR}/usrp_n310_fpga_XG.dts ${D}/usr/share/uhd/images/usrp_n310_fpga_XG.dts
    install -m 0644 ${WORKDIR}/usrp_n310_fpga_AA.dts ${D}/usr/share/uhd/images/usrp_n310_fpga_AA.dts
    install -m 0644 ${WORKDIR}/usrp_n310_fpga_WX.dts ${D}/usr/share/uhd/images/usrp_n310_fpga_WX.dts
    install -m 0644 ${WORKDIR}/usrp_n300_fpga_HG.dts ${D}/usr/share/uhd/images/usrp_n300_fpga_HG.bit
    install -m 0644 ${WORKDIR}/usrp_n300_fpga_XG.dts ${D}/usr/share/uhd/images/usrp_n300_fpga_XG.dts
    install -m 0644 ${WORKDIR}/usrp_n300_fpga_AA.dts ${D}/usr/share/uhd/images/usrp_n300_fpga_AA.dts
    install -m 0644 ${WORKDIR}/usrp_n300_fpga_WX.dts ${D}/usr/share/uhd/images/usrp_n300_fpga_WX.dts
}

PACKAGES_append_ni-sulfur = " \
    ${PN}-sulfur \
    ${PN}-phosphorus \
    ${PN}-rhodium \
"

FILES_${PN}-sulfur = " \
    /usr/share/uhd/images/usrp_n310_fpga_HG.bit \
    /usr/share/uhd/images/usrp_n310_fpga_XG.bit \
    /usr/share/uhd/images/usrp_n310_fpga_AA.bit \
    /usr/share/uhd/images/usrp_n310_fpga_WX.bit \
    /usr/share/uhd/images/usrp_n310_fpga_HG.dts \
    /usr/share/uhd/images/usrp_n310_fpga_XG.dts \
    /usr/share/uhd/images/usrp_n310_fpga_AA.dts \
    /usr/share/uhd/images/usrp_n310_fpga_WX.dts \
"

FILES_${PN}-phosphorus = " \
    /usr/share/uhd/images/usrp_n300_fpga_HG.bit \
    /usr/share/uhd/images/usrp_n300_fpga_XG.bit \
    /usr/share/uhd/images/usrp_n300_fpga_AA.bit \
    /usr/share/uhd/images/usrp_n300_fpga_WX.bit \
    /usr/share/uhd/images/usrp_n300_fpga_HG.dts \
    /usr/share/uhd/images/usrp_n300_fpga_XG.dts \
    /usr/share/uhd/images/usrp_n300_fpga_AA.dts \
    /usr/share/uhd/images/usrp_n300_fpga_WX.dts \
"

FILES_${PN}-rhodium = " \
    /usr/share/uhd/images/usrp_n320_fpga_AQ.bit \
    /usr/share/uhd/images/usrp_n320_fpga_XQ.bit \
    /usr/share/uhd/images/usrp_n320_fpga_HG.bit \
    /usr/share/uhd/images/usrp_n320_fpga_XG.bit \
    /usr/share/uhd/images/usrp_n320_fpga_WX.bit \
    /usr/share/uhd/images/usrp_n320_fpga_AQ.dts \
    /usr/share/uhd/images/usrp_n320_fpga_XQ.dts \
    /usr/share/uhd/images/usrp_n320_fpga_HG.dts \
    /usr/share/uhd/images/usrp_n320_fpga_XG.dts \
    /usr/share/uhd/images/usrp_n320_fpga_WX.dts \
"
