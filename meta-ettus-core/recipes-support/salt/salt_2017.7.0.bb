HOMEPAGE = "http://saltstack.com/"
SECTION = "admin"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=fb92f464675f6b5df90f540d60237915"
DEPENDS = "\
           python3-msgpack \
           python3-pyyaml \
           python3-jinja2 \
           python3-markupsafe \
"

#PACKAGECONFIG ??= "zeromq"
PACKAGECONFIG[zeromq] = ",,python3-pyzmq python3-pycrypto,"
PACKAGECONFIG[tcp] = ",,python3-pycrypto"

SRC_URI = "https://files.pythonhosted.org/packages/source/s/${PN}/${PN}-${PV}.tar.gz \
           file://set_python_location_hashbang.patch \
           file://minion \
           file://salt-minion \
           file://salt-minion.service \
           file://salt-common.bash_completion \
           file://salt-common.logrotate \
           file://salt-api \
           file://salt-master \
           file://master \
           file://salt-syndic \
           file://cloud \
           file://roster \
"

SRC_URI[md5sum] = "955d57b39cac5762f33e2e7ca7ea39de"
SRC_URI[sha256sum] = "aaf45f8dcf95a20b56072e620100432d058ab297210c4902dc90e197b236b064"

S = "${WORKDIR}/${PN}-${PV}"

inherit setuptools3 update-rc.d

# Avoid a QA Warning triggered by the test package including a file
# with a .a extension
INSANE_SKIP_${PN}-tests += "staticdev"

# Note ${PN}-tests must be before ${PN}-common in the PACKAGES variable
# in order for ${PN}-tests to own the correct FILES.
PACKAGES += "\
           ${PN}-tests \
           ${PN}-api \
           ${PN}-cloud \
           ${PN}-common \
           ${PN}-master \
           ${PN}-minion \
           ${PN}-ssh \
           ${PN}-syndic \
           ${PN}-bash-completion \
"

do_install_append() {
        install -d ${D}${sysconfdir}/bash_completion.d/
        install -m 0644 ${WORKDIR}/salt-common.bash_completion ${D}${sysconfdir}/bash_completion.d/${PN}-common
        install -d ${D}${sysconfdir}/logrotate.d/
        install -m 0644 ${WORKDIR}/salt-common.logrotate ${D}${sysconfdir}/logrotate.d/${PN}-common
        install -d ${D}${sysconfdir}/init.d/
        install -m 0755 ${WORKDIR}/salt-minion ${D}${sysconfdir}/init.d/${PN}-minion
        install -m 0755 ${WORKDIR}/salt-api ${D}${sysconfdir}/init.d/${PN}-api
        install -m 0755 ${WORKDIR}/salt-master ${D}${sysconfdir}/init.d/${PN}-master
        install -m 0755 ${WORKDIR}/salt-syndic ${D}${sysconfdir}/init.d/${PN}-syndic
        install -d ${D}${sysconfdir}/${PN}/
        install -m 0644 ${WORKDIR}/minion ${D}${sysconfdir}/${PN}/minion
        install -m 0644 ${WORKDIR}/master ${D}${sysconfdir}/${PN}/master
        install -m 0644 ${WORKDIR}/cloud ${D}${sysconfdir}/${PN}/cloud
        install -m 0644 ${WORKDIR}/roster ${D}${sysconfdir}/${PN}/roster
        install -d ${D}${sysconfdir}/${PN}/cloud.conf.d ${D}${sysconfdir}/${PN}/cloud.profiles.d ${D}${sysconfdir}/${PN}/cloud.providers.d

        install -d ${D}${base_libdir}/systemd/system
        install -m 0644 ${WORKDIR}/salt-minion.service ${D}${base_libdir}/systemd/system/

        install -d ${D}${PYTHON_SITEPACKAGES_DIR}/${PN}-tests/
        cp -r ${S}/tests/ ${D}${PYTHON_SITEPACKAGES_DIR}/${PN}-tests/
}

ALLOW_EMPTY_${PN} = "1"
FILES_${PN} = ""

INITSCRIPT_PACKAGES = "${PN}-minion ${PN}-api ${PN}-master ${PN}-syndic"

DESCRIPTION_COMMON = "salt is a powerful remote execution manager that can be used to administer servers in a\
 fast and efficient way. It allows commands to be executed across large groups of servers. This means systems\
 can be easily managed, but data can also be easily gathered. Quick introspection into running systems becomes\
 a reality. Remote execution is usually used to set up a certain state on a remote system. Salt addresses this\
 problem as well, the salt state system uses salt state files to define the state a server needs to be in. \
Between the remote execution system, and state management Salt addresses the backbone of cloud and data center\
 management."

SUMMARY_${PN}-minion = "client package for salt, the distributed remote execution system"
DESCRIPTION_${PN}-minion = "${DESCRIPTION_COMMON} This particular package provides the worker agent for salt."
RDEPENDS_${PN}-minion = "python3 ${PN}-common (= ${EXTENDPKGV}) python3-msgpack"
RDEPENDS_${PN}-minion += "${@bb.utils.contains('PACKAGECONFIG', 'zeromq', 'python3-pycrypto python3-pyzmq ', '',d)}"
RDEPENDS_${PN}-minion += "${@bb.utils.contains('PACKAGECONFIG', 'tcp', 'python3-pycrypto', '',d)}"
RRECOMMENDS_${PN}-minion_append_x64 = "dmidecode"
RSUGGESTS_${PN}-minion = "python3-augeas"
CONFFILES_${PN}-minion = "${sysconfdir}/${PN}/minion \
                          ${sysconfdir}/init.d/${PN}-minion \
                          ${base_libdir} \
                          ${base_libdir}/systemd \
                          ${base_libdir}/systemd/system \
                          ${base_libdir}/systemd/system/salt-minion.service \
                         "
FILES_${PN}-minion = "${bindir}/${PN}-minion ${sysconfdir}/${PN}/minion.d/ ${CONFFILES_${PN}-minion} ${bindir}/${PN}-proxy"
INITSCRIPT_NAME_${PN}-minion = "${PN}-minion"
INITSCRIPT_PARAMS_${PN}-minion = "defaults"

SUMMARY_${PN}-common = "shared libraries that salt requires for all packages"
DESCRIPTION_${PN}-common ="${DESCRIPTION_COMMON} This particular package provides shared libraries that \
salt-master, salt-minion, and salt-syndic require to function."
RDEPENDS_${PN}-common = "python3 python3-dateutil python3-jinja2 python3-pyyaml python3-requests (>= 1.0.0) python3-tornado (>= 4.2.1)"
RRECOMMENDS_${PN}-common = "lsb python3-futures"
RSUGGESTS_${PN}-common = "python3-mako python3-git"
RCONFLICTS_${PN}-common = "python3-mako (< 0.7.0)"
CONFFILES_${PN}-common="${sysconfdir}/logrotate.d/${PN}-common"
FILES_${PN}-common = "${bindir}/${PN}-call ${libdir}/python3.5/ ${CONFFILES_${PN}-common}"

SUMMARY_${PN}-ssh = "remote manager to administer servers via salt"
DESCRIPTION_${PN}-ssh = "${DESCRIPTION_COMMON} This particular package provides the salt ssh controller. It \
is able to run salt modules and states on remote hosts via ssh. No minion or other salt specific software needs\
 to be installed on the remote host."
RDEPENDS_${PN}-ssh = "python3 ${PN}-common (= ${EXTENDPKGV}) python3-msgpack"
CONFFILES_${PN}-ssh="${sysconfdir}/${PN}/roster"
FILES_${PN}-ssh = "${bindir}/${PN}-ssh ${CONFFILES_${PN}-ssh}"

SUMMARY_${PN}-api = "generic, modular network access system"
DESCRIPTION_${PN}-api = "a modular interface on top of Salt that can provide a variety of entry points into a \
running Salt system. It can start and manage multiple interfaces allowing a REST API to coexist with XMLRPC or \
even a Websocket API. The Salt API system is used to expose the fundamental aspects of Salt control to external\
 sources. salt-api acts as the bridge between Salt itself and REST, Websockets, etc. Documentation is available\
 on Read the Docs: http://salt-api.readthedocs.org/"
RDEPENDS_${PN}-api = "python3 ${PN}-master"
RSUGGESTS_${PN}-api = "python3-cherrypy"
CONFFILES_${PN}-api = "${sysconfdir}/init.d/${PN}-api"
FILES_${PN}-api = "${bindir}/${PN}-api ${CONFFILES_${PN}-api}"
INITSCRIPT_NAME_${PN}-api = "${PN}-api"
INITSCRIPT_PARAMS_${PN}-api = "defaults"

SUMMARY_${PN}-master = "remote manager to administer servers via salt"
DESCRIPTION_${PN}-master ="${DESCRIPTION_COMMON} This particular package provides the salt controller."
RDEPENDS_${PN}-master = "python3 ${PN}-common (= ${EXTENDPKGV}) python3-msgpack"
RDEPENDS_${PN}-master += "${@bb.utils.contains('PACKAGECONFIG', 'zeromq', 'python3-pycrypto python3-pyzmq (>= 13.1.0)', '',d)}"
RDEPENDS_${PN}-master += "${@bb.utils.contains('PACKAGECONFIG', 'tcp', 'python3-pycrypto', '',d)}"
CONFFILES_${PN}-master="${sysconfdir}/init.d/${PN}-master  ${sysconfdir}/${PN}/master"
RSUGGESTS_${PN}-master = "python3-git"
FILES_${PN}-master = "${bindir}/${PN} ${bindir}/${PN}-cp ${bindir}/${PN}-key ${bindir}/${PN}-master ${bindir}/${PN}-run ${bindir}/${PN}-unity ${bindir}/spm ${CONFFILES_${PN}-master}"
INITSCRIPT_NAME_${PN}-master = "${PN}-master"
INITSCRIPT_PARAMS_${PN}-master = "defaults"

SUMMARY_${PN}-syndic = "master-of-masters for salt, the distributed remote execution system"
DESCRIPTION_${PN}-syndic = "${DESCRIPTION_COMMON} This particular package provides the master of masters for \
salt; it enables the management of multiple masters at a time."
RDEPENDS_${PN}-syndic = "python3 ${PN}-master (= ${EXTENDPKGV})"
CONFFILES_${PN}-syndic="${sysconfdir}/init.d/${PN}-syndic"
FILES_${PN}-syndic = "${bindir}/${PN}-syndic ${CONFFILES_${PN}-syndic}"
INITSCRIPT_NAME_${PN}-syndic = "${PN}-syndic"
INITSCRIPT_PARAMS_${PN}-syndic = "defaults"

SUMMARY_${PN}-cloud = "public cloud VM management system"
DESCRIPTION_${PN}-cloud = "provision virtual machines on various public clouds via a cleanly controlled profile and mapping system."
RDEPENDS_${PN}-cloud = "python3 ${PN}-common (= ${EXTENDPKGV})"
RSUGGESTS_${PN}-cloud = "python3-netaddr python3-botocore"
CONFFILES_${PN}-cloud = "${sysconfdir}/${PN}/cloud"
FILES_${PN}-cloud = "${bindir}/${PN}-cloud ${sysconfdir}/${PN}/cloud.conf.d/ ${sysconfdir}/${PN}/cloud.profiles.d/ ${sysconfdir}/${PN}/cloud.providers.d/ ${CONFFILES_${PN}-cloud}"

SUMMARY_${PN}-tests = "salt stack test suite"
DESCRIPTION_${PN}-tests ="${DESCRIPTION_COMMON} This particular package provides the salt unit test suite."
RDEPENDS_${PN}-tests = "${PN}-common python3-pytest-salt python3-tests python3-image bash"
FILES_${PN}-tests = "${PYTHON_SITEPACKAGES_DIR}/salt-tests/tests/"

FILES_${PN}-bash-completion = "${sysconfdir}/bash_completion.d/${PN}-common"

inherit systemd

SYSTEMD_SERVICE_${PN}-minion = "salt-minion.service"
