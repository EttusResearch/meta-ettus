require recipes/uhd/uhd.inc

INHERIT += "srctree"

EXTRA_OECMAKE += "-DENABLE_USRP_E100=TRUE"

PR = "${INC_PR}.0"

#PV = "${GITVER}"

# Set S (the path to the source directory) via local.conf using the line:
# S_pn-uhd-srctree = "/home/username/src/git/uhd/host"

do_clean_append() {
	oe.path.remove(d.getVar("OECMAKE_BUILDPATH", True))
}

UHD_COPY_TO_TARGET = "192.168.1.137"

# Set UHD_COPY_TO_TARGET to the ip address of a board to copy the built files to
# Make sure the scp will work without requiring user input, otherwise the
# command hangs. To copy files to the target run:
# bitbake -c copy_to_target uhd-srctree

do_copy_to_target() {
    scp -rp ${D}/* root@${UHD_COPY_TO_TARGET}:/
}
addtask copy_to_target after do_install
