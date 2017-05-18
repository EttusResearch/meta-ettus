FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_ni-sulfur = " file://system.conf \
                             file://eth.network \
                           "

def get_systemd_req_features(d):
    pkg = d.getVar('PACKAGECONFIG', False)
    li = []
    if 'networkd' not in pkg:
       li.append('networkd')

    if 'resolved' not in pkg:
       li.append('resolved')

    if 'logind' not in pkg:
       li.append('logind')

    if 'timedated' not in pkg:
       li.append('timedated')

    if 'timesyncd' not in pkg:
       li.append('timesyncd')

    return ' '.join(li)

PACKAGECONFIG_append = " ${@get_systemd_req_features(d)}"

do_install_append() {
    install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd
}
