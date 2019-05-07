FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " http://files.ettus.com/binaries/cache/e3xx/fpga-f52a643/e3xx_e310_sg1_fpga_default-gf52a643.zip;name=e31x-sg1-fpga \
	          http://files.ettus.com/binaries/cache/e3xx/fpga-f52a643/e3xx_e310_sg3_fpga_default-gf52a643.zip;name=e31x-sg3-fpga \
                 "
SRC_URI[e31x-sg1-fpga.sha256sum] = "03450918a7c312d53926f3318ea91a57162c545ada4058b9e83a4e0efd4755a4"
SRC_URI[e31x-sg3-fpga.sha256sum] = "e8264dd48c3c3f6e65c8e5ef34a3629aa79a3f17ba845659e553bdcf3dfac303"

PACKAGES =+ " \
    ${PN}-ni-e31x-sg1-fpga \
    ${PN}-ni-e31x-sg3-fpga \
    "

DEPENDS += "dtc-native python3-native"

do_compile_append_ni-e31x() {
    dtc -@ -o ${WORKDIR}/e310_sg1.dtbo ${WORKDIR}/usrp_e310_sg1_fpga.dts
    dtc -@ -o ${WORKDIR}/e310_sg1_idle.dtbo ${WORKDIR}/usrp_e310_sg1_idle_fpga.dts
    python3 ${WORKDIR}/fpga_bit_to_bin.py -f ${WORKDIR}/usrp_e310_sg1_fpga.bit ${WORKDIR}/e310_sg1.bin
    python3 ${WORKDIR}/fpga_bit_to_bin.py -f ${WORKDIR}/usrp_e310_sg1_idle_fpga.bit ${WORKDIR}/e310_sg1_idle.bin
    dtc -@ -o ${WORKDIR}/e310_sg3.dtbo ${WORKDIR}/usrp_e310_sg3_fpga.dts
    dtc -@ -o ${WORKDIR}/e310_sg3_idle.dtbo ${WORKDIR}/usrp_e310_sg3_idle_fpga.dts
    python3 ${WORKDIR}/fpga_bit_to_bin.py -f ${WORKDIR}/usrp_e310_sg3_fpga.bit ${WORKDIR}/e310_sg3.bin
    python3 ${WORKDIR}/fpga_bit_to_bin.py -f ${WORKDIR}/usrp_e310_sg3_idle_fpga.bit ${WORKDIR}/e310_sg3_idle.bin
}

do_install_append_ni-e31x() {
    install -m 0644 ${WORKDIR}/e310_sg1.bin ${D}/lib/firmware/e310_sg1.bin
    install -m 0644 ${WORKDIR}/e310_sg1.dtbo ${D}/lib/firmware/e310_sg1.dtbo
    install -m 0644 ${WORKDIR}/e310_sg1_idle.bin ${D}/lib/firmware/e310_sg1_idle.bin
    install -m 0644 ${WORKDIR}/e310_sg1_idle.dtbo ${D}/lib/firmware/e310_sg1_idle.dtbo
    install -m 0644 ${WORKDIR}/e310_sg3.bin ${D}/lib/firmware/e310_sg3.bin
    install -m 0644 ${WORKDIR}/e310_sg3.dtbo ${D}/lib/firmware/e310_sg3.dtbo
    install -m 0644 ${WORKDIR}/e310_sg3_idle.bin ${D}/lib/firmware/e310_sg3_idle.bin
    install -m 0644 ${WORKDIR}/e310_sg3_idle.dtbo ${D}/lib/firmware/e310_sg3_idle.dtbo
}

FILES_${PN}-ni-e31x-sg1-fpga = " \
                              /lib/firmware/e310_sg1.bin \
                              /lib/firmware/e310_sg1.dtbo \
                              /lib/firmware/e310_sg1_idle.bin \
                              /lib/firmware/e310_sg1_idle.dtbo \
                             "

FILES_${PN}-ni-e31x-sg3-fpga = " \
                              /lib/firmware/e310_sg3.bin \
                              /lib/firmware/e310_sg3.dtbo \
                              /lib/firmware/e310_sg3_idle.bin \
                              /lib/firmware/e310_sg3_idle.dtbo \
                             "
