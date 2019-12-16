FILESEXTRAPATHS_prepend_ni-sulfur := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " http://files.ettus.com/binaries/cache/n3xx/fpga-fde2a94eb/n3xx_n310_fpga_default-gfde2a94e.zip;name=sulfur-fpga;unpack=false \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-fde2a94eb/n3xx_n300_fpga_default-gfde2a94e.zip;name=phosphorus-fpga;unpack=false \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-fde2a94eb/n3xx_n320_fpga_default-gfde2a94e.zip;name=rhodium-fpga;unpack=false \
                           "

SRC_URI[sulfur-fpga.sha256sum] = "4a45e2d4ec41d34fc550402928248a15488ba7b58d835ef2d4f503556173764a"
SRC_URI[sulfur-fpga-aurora.sha256sum] = "3926d6b247a8f931809460d3957cec51f8407cd3f7aea6f4f3b91d1bbb427c7d"

SRC_URI[phosphorus-fpga.sha256sum] = "7f1b512756ae225f8caaf20fd22d2e1537ea211b2fd6c4c9ed1330065fb56645"
SRC_URI[phosphorus-fpga-aurora.sha256sum] = "e34e9343572adfba905433a1570cb394fe45207d442268d0fa400c3406253530"

SRC_URI[rhodium-fpga.sha256sum] = "4fae9de2ede7ff446da8afb61808868c08ba32f8e3092b802c5d4d7643c7175f"

IMAGE_MANIFEST_BINARIES_ni-sulfur = "n3xx_n310_fpga_default n3xx_n300_fpga_default n3xx_n320_fpga_default"

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
