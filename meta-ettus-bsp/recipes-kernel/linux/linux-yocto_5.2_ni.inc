FILESEXTRAPATHS:prepend := "${THISDIR}/linux-yocto-5.2/ni-e31x:${THISDIR}/linux-yocto-5.2/ni-common:"
FILESEXTRAPATHS:prepend := "${THISDIR}/linux-yocto-5.2/ni-neon:${THISDIR}/linux-yocto-5.2/ni-common:"
FILESEXTRAPATHS:prepend := "${THISDIR}/linux-yocto-5.2/ni-sulfur:${THISDIR}/linux-yocto-5.2/ni-common:"

SRC_URI:append = " \
        file://defconfig \
        file://core.scc \
        file://core.cfg \
        file://debug.cfg \
        file://usrp.scc \
        file://usrp.cfg \
        file://sound.cfg \
        "

SRC_URI:append:ni-e31x = " \
        file://ni-e31x.scc \
        file://ni-e31x.cfg \
        file://netfilter_minimal.cfg \
        "

SRC_URI:append:ni-neon = " \
        file://ni-neon.scc \
        file://ni-neon.cfg \
        file://netfilter_minimal.cfg \
        "

SRC_URI:append:ni-sulfur = " \
        file://ni-sulfur.scc \
        file://ni-sulfur.cfg \
        file://netfilter_minimal.cfg \
        "

KERNEL_EXTRA_FEATURES:ni-e31x = ""
KERNEL_EXTRA_FEATURES:ni-neon = ""
KERNEL_EXTRA_FEATURES:ni-sulfur = ""

COMPATIBLE_MACHINE:ni-e31x = "ni-e31x"
COMPATIBLE_MACHINE:ni-neon = "ni-neon-rev1|ni-neon-rev2"
COMPATIBLE_MACHINE:ni-sulfur = "ni-sulfur-rev3|ni-sulfur-rev4|ni-sulfur-rev5|ni-sulfur-rev6|ni-sulfur-rev11"

KCONFIG_MODE:ni-e31x ?= "--alldefconfig"
KCONFIG_MODE:ni-neon ?= "--alldefconfig"
KCONFIG_MODE:ni-sulfur ?= "--alldefconfig"
