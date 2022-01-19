TESTRESULTS_DIR ?= "${WORKDIR}/testresults"
RM_WORK_EXCLUDE_ITEMS += "testresults"

do_run_tests() {
    cd ${B}
    ctest --no-compress-output -T Test
    rm -rf ${TESTRESULTS_DIR}/${PN}
    mkdir -p ${TESTRESULTS_DIR}/${PN}
    mv ${B}/Testing ${TESTRESULTS_DIR}/${PN}
}
addtask run_tests after do_compile
