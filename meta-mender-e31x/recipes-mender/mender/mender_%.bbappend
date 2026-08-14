SYSTEMD_AUTO_ENABLE:ni-e31x-mender = "disable"

# mender-flash does not work as expected on Zynq based devices
# and leads to the following error when running "mender install (...)":
#     Could not fulfill request: Broken pipe: AsyncWrite failed
RRECOMMENDS:mender-update:remove:ni-e31x-mender = "mender-flash"
