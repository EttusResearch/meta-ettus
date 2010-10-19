include recipes/gnuradio/gnuradio.inc

inherit srctree autotools gitver

PV = "${GITVER}"

# Set S (the path to the source directory) via local.conf using the line:
# S_pn-gnuradio-srctree = "/home/username/src/git/gnuradio"

#do_copy_to_target() {
#    scp -rp ${D}/* root@192.168.1.171:/
#}
#addtask copy_to_target after do_install before do_package
