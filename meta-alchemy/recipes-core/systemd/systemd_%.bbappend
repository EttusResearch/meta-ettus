FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
                 file://timesyncd.conf \
"

FILES_${PN}_append = " \
                     ${sysconfdir}/systemd/timesyncd.conf \
"

do_install_append() {
  if ${@bb.utils.contains('PACKAGECONFIG','timesyncd','true','false',d)}; then
    install -d ${D}${sysconfdir}/systemd

    if [ -e ${D}${sysconfdir}/systemd/timesyncd.conf ]; then
      rm ${D}${sysconfdir}/systemd/timesyncd.conf
    fi;

    install -m 0644 ${WORKDIR}/timesyncd.conf ${D}${sysconfdir}/systemd/timesyncd.conf
  fi;

  sed -i -e 's/#RuntimeWatchdogSec=0/RuntimeWatchdogSec=10/g' ${D}${sysconfdir}/systemd/system.conf
}
