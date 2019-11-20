FILESEXTRAPATHS_prepend_ni-e31x := "${THISDIR}/files:"

SRC_URI_append_ni-e31x = " http://files.ettus.com/binaries/cache/e3xx/fpga-ce49fcb/e3xx_e310_sg1_fpga_default-gce49fcb.zip;name=e31x-sg1-fpga;unpack=false \
                           http://files.ettus.com/binaries/cache/e3xx/fpga-ce49fcb/e3xx_e310_sg3_fpga_default-gce49fcb.zip;name=e31x-sg3-fpga;unpack=false \
                         "

SRC_URI[e31x-sg1-fpga.sha256sum] = "a7b58db9859669e54db25e6623b989cfb23d09dd1f36a892e0a1b58c1dde0ec1"
SRC_URI[e31x-sg3-fpga.sha256sum] = "effd4e8b298ee21d7b0d1983a6247bc7703c2f8ff05761a43f526568e08fe27d"

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
