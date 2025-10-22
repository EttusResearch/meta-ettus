SUMMARY = "Pytest Salt Plugin"
HOMEPAGE = "https://github.com/saltstack/pytest-salt-factories"
SECTION = "devel/python"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5bb8b5f5849c2491dbbf50d73d3839f1"

PYPI_PACKAGE = "pytest_salt_factories"
SRC_URI[sha256sum] = "13e020a938292ffc33d2247c5d094a532c53fd89d3ecb70bcda98f15d7846bc7"

DEPENDS += "python3-cython-native python3-setuptools-declarative-requirements-native python3-setuptools-scm-native"

inherit pypi python_setuptools_build_meta

DEPENDS += "python3-toml-native"

# TODO: check and adjust requirements
RDEPENDS:${PN} = " \
    ${PYTHON_PN}-pytest \
    ${PYTHON_PN}-pytest-tempdir \
    ${PYTHON_PN}-pytest-helpers-namespace \
    ${PYTHON_PN}-psutil \
    "
