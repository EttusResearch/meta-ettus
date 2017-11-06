#@TYPE: Machine
#@DESCRIPTION: Base configuration for the Ettus Research Zynq based products.

PREFERRED_PROVIDER_virtual/kernel ?= "linux-yocto"

include conf/machine/include/tune-zynq.inc

PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot"
