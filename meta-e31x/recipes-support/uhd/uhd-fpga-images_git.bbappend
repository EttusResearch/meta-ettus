FILESEXTRAPATHS_prepend_ni-e31x := "${THISDIR}/files:"

SRC_URI_append_ni-e31x = " http://files.ettus.com/binaries/cache/e3xx/fpga-9e3d00c/e3xx_e310_sg1_fpga_default-g9e3d00c.zip;name=e31x-sg1-fpga;unpack=false \
                           http://files.ettus.com/binaries/cache/e3xx/fpga-9e3d00c/e3xx_e310_sg3_fpga_default-g9e3d00c.zip;name=e31x-sg3-fpga;unpack=false \
                         "

SRC_URI[e31x-sg1-fpga.sha256sum] = "9df2a6749f6a307eaccc6956f17e753689719ecbf9563ae77f492e7f7776d257"
SRC_URI[e31x-sg3-fpga.sha256sum] = "1cd58559ae009319b7f1d48ca4adb7ccd15d6c116dd91c0662d6ab26fbbc1b0c"

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
