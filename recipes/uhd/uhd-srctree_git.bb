require recipes/uhd/uhd.inc

INHERIT += "srctree"

EXTRA_OECMAKE += "-DENABLE_USRP_E=TRUE"

PR = "${INC_PR}.0"

#PV = "${GITVER}"

# Set S (the path to the source directory) via local.conf using the line:
# S_pn-uhd-srctree = "/home/username/src/git/uhd/host"

#do_copy_to_target() {
#    scp -rp ${D}/* root@192.168.1.171:/
#}
#addtask copy_to_target after do_install before do_package
