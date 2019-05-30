FILESEXTRAPATHS_prepend_ni-sulfur := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " http://files.ettus.com/binaries/cache/n3xx/fpga-e39334fe/n3xx_n310_fpga_default-ge39334fe.zip;name=sulfur-fpga \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-e39334fe/n3xx_n300_fpga_default-ge39334fe.zip;name=phosphorus-fpga \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-e39334fe/n3xx_n320_fpga_default-ge39334fe.zip;name=rhodium-fpga \
                           "

SRC_URI[sulfur-fpga.sha256sum] = "8c557cc5fa4f413609335f50fd7e0eb977af0f4d2ba13ef9f0545d0166ac7ffb"
SRC_URI[sulfur-fpga-aurora.sha256sum] = "3926d6b247a8f931809460d3957cec51f8407cd3f7aea6f4f3b91d1bbb427c7d"

SRC_URI[phosphorus-fpga.sha256sum] = "8b91bc960a7735c8611a1b1aad6d511f362625d06c82744456449cad8d3542a9"
SRC_URI[phosphorus-fpga-aurora.sha256sum] = "e34e9343572adfba905433a1570cb394fe45207d442268d0fa400c3406253530"

SRC_URI[rhodium-fpga.sha256sum] = "cd79274b5efda0b93433badd7191ccac6a160537c30ec6113fe7a4e000ece6a8"

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
