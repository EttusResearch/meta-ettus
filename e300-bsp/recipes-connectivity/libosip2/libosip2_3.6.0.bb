SUMMARY = "GNU osip2 core library for sip protocol"
DESCRIPTION = "The GNU oSIP library is an implementation of SIP - rfc3261."
HOMEPAGE = "http://www.gnu.org/software/osip/osip.html"
LICENSE = "LGPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=e639b5c15b4bd709b52c4e7d4e2b09a4"

SRC_URI = "http://ftp.gnu.org/gnu/osip/libosip2-3.6.0.tar.gz \
"

SRC_URI[md5sum] = "92fd1c1698235a798497887db159c9b3"
SRC_URI[sha256sum] = "c9a18b0c760506d150017cdb1fa5c1cefe12b8dcbbf9a7e784eb75af376e96cd"

inherit autotools 
