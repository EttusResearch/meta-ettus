inherit task

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

DEPENDS += "libusb1 fftw python alsa-lib jack boost cppunit swig \
            python python-numpy git util-linux gsl python-cheetah git \
            pkgconfig \
            "

RDEPENDS_${PN} += "task-sdk-target libusb1-dev fftwf-dev \
             alsa-dev alsa-lib-dev jack-dev \
             cppunit-dev swig python-dev python-numpy-dev python-textutils \
             python-distutils python-re python-stringold python-lang \
             python-threading python-unittest python-shell python-pickle \
             python-pprint python-compiler python-pkgutil python-pydoc \
             python-mmap python-netclient python-difflib python-compile \
             python-cheetah python-netserver python-xml cmake \
             boost boost-dev gsl-dev git pkgconfig-dev \
             util-linux util-linux-swaponoff \
             "

ALLOW_EMPTY = "1"
PACKAGES = "${PN}"

