FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-4.12:"

SRC_URI_append_ni-sulfur = " \
		file://defconfig \
		file://sulfur.scc \
		"

COMPATIBLE_MACHINE_ni-sulfur = "ni-sulfur-rev2|ni-sulfur-rev3|ni-sulfur-rev4|ni-sulfur-rev5"

KCONFIG_MODE ?= "--alldefconfig"
