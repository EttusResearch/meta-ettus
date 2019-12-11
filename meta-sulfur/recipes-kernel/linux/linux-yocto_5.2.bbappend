FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-5.2:"

SRC_URI_append_ni-sulfur = " \
		file://defconfig \
		file://sulfur.scc \
		file://sulfur.cfg \
		"

COMPATIBLE_MACHINE_ni-sulfur = "ni-sulfur-rev3|ni-sulfur-rev4|ni-sulfur-rev5" \
		"|ni-sulfur-rev6|ni-sulfur-rev11"

KCONFIG_MODE ?= "--alldefconfig"
