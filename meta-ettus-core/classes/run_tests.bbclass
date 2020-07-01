TESTRESULTS_DIR ?= "${WORKDIR}/testresults"
RM_WORK_EXCLUDE_ITEMS += "testresults"

do_run_tests() {
    cd ${B}
    RETVAL=0; ctest --no-compress-output -T Test || RETVAL=$?
    rm -rf ${TESTRESULTS_DIR}/${PN}
    mkdir -p ${TESTRESULTS_DIR}/${PN}
    mv ${B}/Testing ${TESTRESULTS_DIR}/${PN}
    return $RETVAL
}
addtask run_tests after do_compile
