FILESEXTRAPATHS_prepend_ni-e31x := "${THISDIR}/files:"

SRC_URI_append_ni-e31x-sg1  = " http://files.ettus.com/binaries/cache/e3xx/fpga-abdc445a/e3xx_e31x_fpga_default-gabdc445a.zip;name=e31x-sg1-fpga \
           "

SRC_URI_append_ni-e31x-sg3  = " http://files.ettus.com/binaries/cache/e3xx/fpga-abdc445a/e3xx_e1x_fpga_default-gabdc445a.zip;name=e31x-sg3-fpga \
           "

SRC_URI[e31x-sg1-fpga.md5sum] = "46ac1fe80d7c8e8cf242ef0189f6bcbe"
SRC_URI[e31x-sg1-fpga.sha256sum] = "82e5af3742245f1f8ea5dd334b1ceb7920e3c31306d86b0dbf31bedd696879c4"

SRC_URI[e31x-sg3-fpga.md5sum] = "46ac1fe80d7c8e8cf242ef0189f6bcbe"
SRC_URI[e31x-sg3-fpga.sha256sum] = "82e5af3742245f1f8ea5dd334b1ceb7920e3c31306d86b0dbf31bedd696879c4"

do_install_append_ni-e31x-sg1(){
    mkdir -p ${D}/usr/share/uhd/images
    install -m 0644 ${WORKDIR}/usrp_e31x_fpga.bit ${D}/usr/share/uhd/images/usrp_e31x_fpga.bit
    install -m 0644 ${WORKDIR}/usrp_e31x_fpga_idle.bit ${D}/usr/share/uhd/images/usrp_e31x_fpga_idle.bit

    install -m 0644 ${WORKDIR}/usrp_e31x_fpga.dts ${D}/usr/share/uhd/images/usrp_e31x_fpga.dts
    install -m 0644 ${WORKDIR}/usrp_e31x_fpga_idle.dts ${D}/usr/share/uhd/images/usrp_e31x_fpga_idle.dts
}

do_install_append_ni-e31x-sg3(){
    mkdir -p ${D}/usr/share/uhd/images
    install -m 0644 ${WORKDIR}/usrp_e31x_fpga_sg3.bit ${D}/usr/share/uhd/images/usrp_e31x_fpga.bit
    install -m 0644 ${WORKDIR}/usrp_e31x_fpga_sg3_idle.bit ${D}/usr/share/uhd/images/usrp_e31x_fpga_idle.bit

    install -m 0644 ${WORKDIR}/usrp_e31x_fpga_sg3.dts ${D}/usr/share/uhd/images/usrp_e31x_fpga_sg3.dts
    install -m 0644 ${WORKDIR}/usrp_e31x_fpga_sg3_idle.dts ${D}/usr/share/uhd/images/usrp_e31x_fpga_sg3_idle.dts
}

PACKAGES_append_ni-e31x = " \
    ${PN}-e31x \
"

FILES_${PN}-e31x-sg1 = " \
    /usr/share/uhd/images/usrp_e31x_fpga.bit \
    /usr/share/uhd/images/usrp_e31x_fpga_idle.bit \
    /usr/share/uhd/images/usrp_e31x_fpga.dts \
    /usr/share/uhd/images/usrp_e31x_fpga_idle.dts \
"

FILES_${PN}-e31x-sg3 = " \
    /usr/share/uhd/images/usrp_e31x_fpga_sg3.bit \
    /usr/share/uhd/images/usrp_e31x_fpga_sg3_idle.bit \
    /usr/share/uhd/images/usrp_e31x_fpga_sg3.dts \
    /usr/share/uhd/images/usrp_e31x_fpga_sg3_idle.dts \
"
