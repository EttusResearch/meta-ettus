FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-4.18:"

SRC_URI_append_ni-sulfur = " \
		file://defconfig \
		file://sulfur.scc \
		"

COMPATIBLE_MACHINE_ni-sulfur = "ni-sulfur-rev3|ni-sulfur-rev4|ni-sulfur-rev5|ni-sulfur-rev6"

KCONFIG_MODE ?= "--alldefconfig"
