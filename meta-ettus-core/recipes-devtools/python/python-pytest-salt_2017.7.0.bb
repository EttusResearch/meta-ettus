SUMMARY = "This pytest plugin will allow the Salt Daemons to be used in tests."
HOMEPAGE = "https://github.com/saltstack/pytest-salt"
SECTION = "devel/python"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=fa818a259cbed7ce8bc2a22d35a464fc"

SRCNAME = "pytest-salt"
SRC_URI = "git://github.com/saltstack/${SRCNAME}.git;branch=master"

SRC_URI[md5sum] = "c598d7db87ea52cdeb067d7596b3b0b1"
SRC_URI[sha256sum] = "7052459cda9fbdbbfff9a25b24243b0b96cf56835a2c41135d754cc5b65e2494"

SRCREV = "feb5031f80cf84b113ebe69543cdd44b6a373d21"
S = "${WORKDIR}/git"

inherit setuptools3

RDEPENDS_${PN} = " \
    python3-pytest \
    python3-pytest-tempdir \
    python3-pytest-helpers-namespace \
    python3-psutil \
    "
