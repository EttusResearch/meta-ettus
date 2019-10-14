FILESEXTRAPATHS_prepend_ni-sulfur := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " http://files.ettus.com/binaries/cache/n3xx/fpga-9e3d00c/n3xx_n310_fpga_default-g9e3d00c.zip;name=sulfur-fpga;unpack=false \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-9e3d00c/n3xx_n300_fpga_default-g9e3d00c.zip;name=phosphorus-fpga;unpack=false \
                             http://files.ettus.com/binaries/cache/n3xx/fpga-9e3d00c/n3xx_n320_fpga_default-g9e3d00c.zip;name=rhodium-fpga;unpack=false \
                           "

SRC_URI[sulfur-fpga.sha256sum] = "b6ba63f0b36081526aec085708676d727039ee8fb639cd0a944ba4ac719c3640"
SRC_URI[sulfur-fpga-aurora.sha256sum] = "3926d6b247a8f931809460d3957cec51f8407cd3f7aea6f4f3b91d1bbb427c7d"

SRC_URI[phosphorus-fpga.sha256sum] = "fb6af0d9d4744a1354b7f42fc8583b37964b36ef8ea4cddc073eac68fc0533bc"
SRC_URI[phosphorus-fpga-aurora.sha256sum] = "e34e9343572adfba905433a1570cb394fe45207d442268d0fa400c3406253530"

SRC_URI[rhodium-fpga.sha256sum] = "40dfb873a294cd574d5ca24de6d1908bb6257bc0db5204c70de90589227915c6"

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
