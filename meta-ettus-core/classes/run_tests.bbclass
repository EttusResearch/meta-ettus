TESTRESULTS_DIR ?= "${WORKDIR}/testresults"
RM_WORK_EXCLUDE_ITEMS += "testresults"

do_run_tests[network] = "1"
do_run_tests() {
    ret=0
    cd ${B}
    ctest --no-compress-output --output-on-failure -T Test || ret=$?
    rm -rf ${TESTRESULTS_DIR}/${PN}
    mkdir -p ${TESTRESULTS_DIR}/${PN}
    mv ${B}/Testing ${TESTRESULTS_DIR}/${PN}
    exit $ret
}
addtask run_tests after do_compile
