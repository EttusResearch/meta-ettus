LIC_FILES_CHKSUM ?= "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

require recipes-kernel/linux/linux-yocto.inc

KERNEL_VERSION_SANITY_SKIP="1"

KBRANCH = "usrp-v6.12"
LINUX_VERSION = "6.12.57-rt14"
SRCREV = "cd28beffb5981a06b6d266312e75bcc3c767dc1c"
KBUILD_DEFCONFIG ?= "usrp_defconfig"

LINUX_VERSION_EXTENSION = "-usrp"
SRC_URI = "git://git@github.com/EttusResearch/linuxdev.git;protocol=ssh;branch=${KBRANCH}"
KCONFIG_MODE ?= "--alldefconfig"
PV = "${LINUX_VERSION}+git${SRCPV}"

KCONF_BSP_AUDIT_LEVEL = "2"

KMACHINE:ni-titanium = "ni-titanium"

COMPATIBLE_MACHINE:ni-e31x = "ni-e31x-sg1|ni-e31x-sg3"
COMPATIBLE_MACHINE:ni-e31x-mender = "ni-e31x-mender-sg3|ni-e31x-mender-sg1"
COMPATIBLE_MACHINE:ni-sulfur-mender = "ni-sulfur-rev3-mender|ni-sulfur-rev4-mender|ni-sulfur-rev5-mender|ni-sulfur-rev6-mender"
COMPATIBLE_MACHINE:ni-neon = "ni-neon-rev1|ni-neon-rev2"
COMPATIBLE_MACHINE:ni-sulfur = "ni-sulfur-rev3|ni-sulfur-rev4|ni-sulfur-rev5|ni-sulfur-rev6|ni-sulfur-rev11"
COMPATIBLE_MACHINE:ni-titanium = "ni-titanium-rev2|ni-titanium-rev3|ni-titanium-rev4|ni-titanium-rev5"
