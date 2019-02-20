FILESEXTRAPATHS_prepend_ni-sulfur := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " http://files.ettus.com/binaries/cache/n3xx/fpga-64da560/n3xx_n310_fpga_default-g64da560.zip;name=sulfur-fpga \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-64da560/n3xx_n300_fpga_default-g64da560.zip;name=phosphorus-fpga \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-4bc2c6f/n3xx_n320_fpga_default-g4bc2c6f.zip;name=rhodium-fpga \
                           "

SRC_URI[sulfur-fpga.sha256sum] = "75debfd43ca782055d69d1cc563909b9e361adcb871f62768da1efac16c6e15d"
SRC_URI[sulfur-fpga-aurora.sha256sum] = "3926d6b247a8f931809460d3957cec51f8407cd3f7aea6f4f3b91d1bbb427c7d"

SRC_URI[phosphorus-fpga.sha256sum] = "7b53e899ef6d1998fc2226ab6d37fded6eb333bbdd4ef38888f0ab24fea348c1"
SRC_URI[phosphorus-fpga-aurora.sha256sum] = "e34e9343572adfba905433a1570cb394fe45207d442268d0fa400c3406253530"

SRC_URI[rhodium-fpga.sha256sum] = "0ef6414a13b6476d3cf015021ec979e75e4e20349b497cfb2ac9affdc4293a90"

do_install_append_ni-sulfur(){
    mkdir -p ${D}/usr/share/uhd/images
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_AQ.bit ${D}/usr/share/uhd/images/usrp_n320_fpga_AQ.bit
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_XQ.bit ${D}/usr/share/uhd/images/usrp_n320_fpga_XQ.bit
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_HG.bit ${D}/usr/share/uhd/images/usrp_n320_fpga_HG.bit
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_XG.bit ${D}/usr/share/uhd/images/usrp_n320_fpga_XG.bit
    install -m 0644 ${WORKDIR}/usrp_n320_fpga_WX.bit ${D}/usr/share/uhd/images/usrp_n320_fpga_WX.bit
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
    install -m 0644 ${WORKDIR}/usrp_n300_fpga_HG.dts ${D}/usr/share/uhd/images/usrp_n300_fpga_HG.dts
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
