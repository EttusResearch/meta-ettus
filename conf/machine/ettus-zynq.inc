#@TYPE: Machine
#@DESCRIPTION: Base configuration for the Ettus Research Zynq based products.

PREFERRED_PROVIDER_virtual/kernel ?= "linux-yocto"

include conf/machine/include/tune-zynq.inc
require conf/machine/include/machine-xilinx-default.inc
require conf/machine/include/machine-xilinx-board.inc

PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot"

IMAGE_BOOT_FILES += "boot.bin"
