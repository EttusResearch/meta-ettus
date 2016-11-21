FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-4.8:"

SRC_URI_append += " \
                file://ettus-e300.scc \
                file://usb-audio.cfg \
                file://usb-cam.cfg \
                file://usb-serial.cfg \
                file://bluetooth.cfg \
                file://usb-wifi.cfg \
		"


