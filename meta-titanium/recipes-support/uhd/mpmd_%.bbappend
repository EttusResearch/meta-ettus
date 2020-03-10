DEPENDS_append_ni-titanium = "libmetal"
MPM_DEVICE_ni-titanium = "x4xx"
EXTRA_OECMAKE_append_ni-titanium = " -DENABLE_OCTOCLOCK=OFF"

SYSTEMD_SERVICE_${PN}_append_ni-titanium = " ${@bb.utils.contains('DISTRO_FEATURES','systemd','usrp-adc-self-cal.service','',d)}"
