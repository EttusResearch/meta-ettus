FILES_${PN}_append_ni-neon-mender = " /data/network/*"

do_install_append_ni-neon-mender() {
    install -d ${D}/data/network/
    for FILENAME in ${D}${base_libdir}/systemd/network/*; do
        cp $FILENAME ${D}/data/network/
        mv $FILENAME $FILENAME.sample
        ln -s /data/network/$(basename $FILENAME) $FILENAME
    done
}

pkg_postinst_ontarget_${PN}() {
    for FILENAME in ${base_libdir}/systemd/network/*.network; do
        if [ -h $FILENAME ] && [ ! -e $FILENAME ]; then
            echo "File $FILENAME is not existing, copying .sample file"
            install -D $FILENAME.sample $(readlink $FILENAME)
        fi
    done
}
