FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-4.10:"

SRC_URI_append_ni-sulfur = " \
		file://sulfur.scc \
		"

COMPATIBLE_MACHINE_ni-sulfur = "ni-sulfur-rev2|ni-sulfur-rev3"
