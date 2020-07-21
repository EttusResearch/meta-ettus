FILES_${PN}_append_ni-e31x-mender = " /data/network"

do_install_append_ni-e31x-mender() {
    mkdir ${D}/data/
    mv ${D}${base_libdir}/systemd/network ${D}/data/
    mkdir ${D}${base_libdir}/systemd/network/
    for FILE in ${D}/data/network/*; do
        ln -s /data/network/$(basename $FILE) ${D}${base_libdir}/systemd/network/
        echo $FILE
    done
}
