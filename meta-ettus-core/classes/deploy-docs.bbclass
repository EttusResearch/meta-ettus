DEPLOYDIR_DOCS = "${PKGDEST}/${PN}-doc/${docdir}"
SSTATETASKS += "do_deploy_docs"
do_deploy_docs[sstate-inputdirs] = "${DEPLOYDIR_DOCS}"
do_deploy_docs[sstate-outputdirs] = "${DEPLOY_DIR}/docs"

do_deploy_docs() {
    :
}

python do_deploy_docs_setscene () {
    sstate_setscene(d)
}
addtask do_deploy_docs_setscene
addtask do_deploy_docs after do_package before do_build
do_deploy_docs[dirs] = "${DEPLOYDIR_DOCS} ${B}"
do_deploy_docs[stamp-extra-info] = "${MACHINE_ARCH}"
