do_install_append() {
  sed -i -e 's/#RuntimeWatchdogSec=0/RuntimeWatchdogSec=10/g' ${D}${sysconfdir}/systemd/system.conf
}
