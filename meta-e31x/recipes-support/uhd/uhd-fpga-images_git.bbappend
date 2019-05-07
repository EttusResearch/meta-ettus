FILESEXTRAPATHS_prepend_ni-e31x := "${THISDIR}/files:"

SRC_URI_append_ni-e31x  = " http://files.ettus.com/binaries/cache/e3xx/fpga-f52a643/e3xx_e310_sg1_fpga_default-gf52a643.zip;name=e31x-sg1-fpga \
                            http://files.ettus.com/binaries/cache/e3xx/fpga-f52a643/e3xx_e310_sg3_fpga_default-gf52a643.zip;name=e31x-sg3-fpga \
           "

SRC_URI[e31x-sg1-fpga.sha256sum] = "03450918a7c312d53926f3318ea91a57162c545ada4058b9e83a4e0efd4755a4"
SRC_URI[e31x-sg3-fpga.sha256sum] = "e8264dd48c3c3f6e65c8e5ef34a3629aa79a3f17ba845659e553bdcf3dfac303"

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
