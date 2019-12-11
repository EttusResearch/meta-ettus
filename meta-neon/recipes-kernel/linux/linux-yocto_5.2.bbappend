FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-5.2:"

SRC_URI_append_ni-neon = " \
                         file://defconfig \
                         file://neon.scc \
                         file://neon.cfg \
                         "

COMPATIBLE_MACHINE_ni-neon = "ni-neon-rev1|ni-neon-rev2"

KCONFIG_MODE ?= "--alldefconfig"
