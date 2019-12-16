FILESEXTRAPATHS_prepend_ni-e31x := "${THISDIR}/files:"

SRC_URI_append_ni-e31x = " http://files.ettus.com/binaries/cache/e3xx/fpga-fde2a94eb/e3xx_e310_sg1_fpga_default-gfde2a94e.zip;name=e31x-sg1-fpga;unpack=false \
                           http://files.ettus.com/binaries/cache/e3xx/fpga-fde2a94eb/e3xx_e310_sg3_fpga_default-gfde2a94e.zip;name=e31x-sg3-fpga;unpack=false \
                         "

SRC_URI[e31x-sg1-fpga.sha256sum] = "ac5f6db65780e944c565977e0bd5085c76d0bcdf246579f13d5da69211590980"
SRC_URI[e31x-sg3-fpga.sha256sum] = "84ddae28d98d02cdeb88b560dc6c1f7280f8d9adcc719bec9774deb7ed6dbb3c"

IMAGE_MANIFEST_BINARIES_ni-e31x = "e3xx_e310_sg1_fpga_default e3xx_e310_sg3_fpga_default"

do_install_append_ni-e31x-sg1(){
    mkdir -p ${D}/usr/share/uhd/images
    install -m 0644 ${WORKDIR}/usrp_e310_sg1_fpga.bit ${D}/usr/share/uhd/images/usrp_e310_sg1_fpga.bit
    install -m 0644 ${WORKDIR}/usrp_e310_sg1_fpga.dts ${D}/usr/share/uhd/images/usrp_e310_sg1_fpga.dts
    install -m 0644 ${WORKDIR}/usrp_e310_sg1_idle_fpga.bit ${D}/usr/share/uhd/images/usrp_e310_sg1_idle_fpga.bit
    install -m 0644 ${WORKDIR}/usrp_e310_sg1_idle_fpga.dts ${D}/usr/share/uhd/images/usrp_e310_sg1_idle_fpga.dts
}

do_install_append_ni-e31x-sg3(){
    mkdir -p ${D}/usr/share/uhd/images
    install -m 0644 ${WORKDIR}/usrp_e310_sg3_fpga.bit ${D}/usr/share/uhd/images/usrp_e310_sg3_fpga.bit
    install -m 0644 ${WORKDIR}/usrp_e310_sg3_fpga.dts ${D}/usr/share/uhd/images/usrp_e310_sg3_fpga.dts
    install -m 0644 ${WORKDIR}/usrp_e310_sg3_idle_fpga.bit ${D}/usr/share/uhd/images/usrp_e310_sg3_idle_fpga.bit
    install -m 0644 ${WORKDIR}/usrp_e310_sg3_idle_fpga.dts ${D}/usr/share/uhd/images/usrp_e310_sg3_idle_fpga.dts
}

PACKAGES_append_ni-e31x = " \
    ${PN}-e31x-sg1 \
    ${PN}-e31x-sg3 \
"

FILES_${PN}-e31x-sg1 = " \
    /usr/share/uhd/images/usrp_e310_sg1_fpga.bit \
    /usr/share/uhd/images/usrp_e310_sg1_fpga.dts \
    /usr/share/uhd/images/usrp_e310_sg1_idle_fpga.bit \
    /usr/share/uhd/images/usrp_e310_sg1_idle_fpga.dts \
"

FILES_${PN}-e31x-sg3 = " \
    /usr/share/uhd/images/usrp_e310_sg3_fpga.bit \
    /usr/share/uhd/images/usrp_e310_sg3_fpga.dts \
    /usr/share/uhd/images/usrp_e310_sg3_idle_fpga.bit \
    /usr/share/uhd/images/usrp_e310_sg3_idle_fpga.dts \
"
