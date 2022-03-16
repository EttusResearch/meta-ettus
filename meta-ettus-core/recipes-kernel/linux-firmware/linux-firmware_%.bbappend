RRECOMMENDS_${PN}_append += "uhd-fpga-images-firmware"

# This override is to address fetch failures because
# the default branch changed from master to main.
# This may not be needed in future versions.
SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git;branch=main"
