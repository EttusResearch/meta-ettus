FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-4.15:"

SRC_URI_append_ni-neon = " \
		file://defconfig \
		file://neon.scc \
		"

COMPATIBLE_MACHINE_ni-neon = "ni-neon-rev1"

KCONFIG_MODE ?= "--alldefconfig"
