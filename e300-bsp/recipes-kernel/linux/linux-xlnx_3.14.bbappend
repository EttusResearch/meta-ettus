FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}-3.14:"

SRC_URI_append_ettus-e300 = "\
                  file://axi-fpga.scc \
                  file://axi-fpga.cfg \
                  file://ettus-e300.scc \
                  file://ettus-e300.cfg \
                  file://usb-audio.cfg \
                  file://usb-wifi.cfg \
                  file://usb-serial.cfg \
                  file://usb-cam.cfg \
                  file://0001-axi_fpga-Add-a-driver-to-test-AXI-interface-to-the-f.patch \
                  file://0001-power-reset-Backport-syscon-poweroff.patch \
                  file://0004-Input-add-support-for-NI-Ettus-Research-USRP-E3x0-bu.patch \
                  file://0006-char-xilinx_xdevcfg-Added-a-notifier-interface.patch \
                  file://0007-power-Add-support-for-NI-Ettus-Research-E3XX-PMU.patch \
                  file://0010-regulator-e3xx-db-Adding-support-for-NI-USRP-E3XX-DB.patch \
		"

COMPATIBLE_MACHINE_ettus-e300 = "ettus-e300"

