SUMMARY = "Pure Python RabbitMQ/AMQP 0-9-1 client library"
HOMEPAGE = "https://github.com/pika/pika"
SECTION = "devel/python"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=fb26c37045f9e0d2c5e24b711bd7f01c"

PV = "0.10.0+git${SRCPV}"
SRCREV = "b907f91415169b7f590174ab5d228e75a1b273e6"

SRC_URI = "git://github.com/pika/pika"

S = "${WORKDIR}/git"

inherit setuptools3
