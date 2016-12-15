FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-4.8:"

SRC_URI_append_ettus-e300 += " \
                file://ettus-e300.scc \
                file://usb-audio.cfg \
                file://usb-cam.cfg \
                file://usb-serial.cfg \
                file://bluetooth.cfg \
                file://usb-wifi.cfg \
		"

COMPATIBLE_MACHINE_ettus-e300 = "ettus-e3xx-sg1|ettus-e3xx-sg3"
COMPATIBLE_MACHINE_sulfur = "sulfur"
