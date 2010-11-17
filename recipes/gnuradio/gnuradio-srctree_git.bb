include recipes/gnuradio/gnuradio.inc

inherit srctree autotools gitver

PV = "${GITVER}"

# Set S (the path to the source directory) via local.conf using the line:
# S_pn-gnuradio-srctree = "/home/username/src/git/gnuradio"

# Set UHD_COPY_TO_TARGET to the ip address of a board to copy the built files to
# Make sure the scp will work without requiring user input, otherwise the
# command hangs. To copy files to the target run:
# bitbake -c copy_to_target gnuradio-srctree

GNURADIO_COPY_TO_TARGET = "192.168.1.137"

do_copy_to_target() {
    scp -rp ${D}/* root@${GNURADIO_COPY_TO_TARGET}:/
}
addtask copy_to_target after do_install
