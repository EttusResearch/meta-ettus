FILESEXTRAPATHS_prepend_ni-neon := "${THISDIR}/files:"

SRC_URI_append_ni-neon = " http://files.ettus.com/binaries/cache/e3xx/fpga-bb85bdff/e3xx_e320_fpga_default-gbb85bdff.zip;name=neon-fpga;unpack=false \
                         "

SRC_URI[neon-fpga.sha256sum] = "4c03a82483eec25fd4908911b2981315d80e4e57edd40632549caf87f697b9f1"
SRC_URI[neon-fpga-aurora.sha256sum] = "73a3851e890df827ec1b809e34cea49cf973ba225ef9852416c77237f18f016c"

IMAGE_MANIFEST_BINARIES_ni-neon = "e3xx_e320_fpga_default"

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
