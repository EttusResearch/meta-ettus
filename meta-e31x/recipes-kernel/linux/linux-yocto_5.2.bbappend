FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-5.2:"

SRC_URI_append_ni-e31x = " \
                         file://e31x.scc \
                         file://e31x.cfg \
                        "

COMPATIBLE_MACHINE_ni-e31x = "ni-e31x-sg1|ni-e31x-sg3"

KCONFIG_MODE ?= "--alldefconfig"
