SUMMARY = "Universal Boot Loader for embedded devices"
PROVIDES = "virtual/bootloader"

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILESEXTRAPATHS:prepend:ni-titanium := "${THISDIR}/files/ni-titanium:"

SRC_URI:prepend:ni-titanium = " \
    file://boot_u-boot.tcl \
    file://boot_u-boot \
    file://0001-misc-cros_ec-Add-trivial-support-for-software-sync.patch \
    file://0002-zynqmp-added-CONFIG_ZYNQMP_SPL_PM_CFG_OBJ_SRC_FILE.patch \
    file://0003-board-ni-add-support-for-X410-rev-B.patch \
    file://0004-board-x410-add-tlv_eeprom-support.patch \
    file://0005-board-x410-pull-eth0-mac-address-from-eeprom.patch \
    file://0006-ni-zynqmp-add-our-own-board.c.patch \
    file://0007-ni-zynqmp-add-helper-for-loading-eeprom.patch \
    file://0008-ni-zynqmp-load-eeproms-at-init.patch \
    file://0009-ni-zynqmp-apply-overlays-based-on-attached-boards.patch \
    file://0010-board-x410-update-psu_init_gpl-to-2019.1.patch \
    file://0011-board-x410-update-rev2-psu_init.patch \
    file://0012-board-ni-add-support-for-X410-Rev-C.patch \
    file://0013-update-peripheral-config-to-allow-bitbranging-GPIO.patch \
    file://0014-board-ni-update-x410-configs.patch \
    file://0015-board-ni-choose-correct-ec-image-based-on-board-rev-.patch \
    file://0016-board-x410-enable-watchdog-timer.patch \
    file://0017-board-x410-enable-watchdog-timer.patch \
    file://0018-board-ni-enable-watchdog-timer-on-x410.patch \
    file://0019-board-x410-set-GPO2-high-by-default.patch \
    file://0020-board-x410-don-t-enable-pull-down-on-MIO34.patch \
    file://0021-ni-zynqmp-add-IF-Test-daughterboard-support.patch \
    file://0022-board-x410-require-noautoboot-to-interrupt-boot.patch \
    file://0023-board-x410-set-LPD-AXI-slave-0-width-to-32-bits.patch \
    file://0024-board-x410-broadcast-inner-shareable-cache-transacti.patch \
    file://0025-board-x410-add-support-for-x410-rev4.patch \
    file://0026-x410-rev4-fix-pull-types-on-PS-SPI-interface.patch \
    file://0027-board-x410-allow-larger-initrd.patch \
    file://0028-configs-x410-Start-using-new-CONFIG_SYS_REDUNDAND_EN.patch \
    file://0029-configs-correct-ni_x410_rev-_defconfigs-files-after-.patch \
    file://0030-ni-zynqmp-fixed-for-U-Boot-v2026.01.patch \
    file://0031-RENAME-fixes.patch \
    file://0032-Fix-Initial-stack-was-in-uninitialized-DDR-causing-c.patch \
    file://0033-Fix-Correct-ni_x410_dev4_defconfig-to-progress-in-th.patch \
    file://0035-Enable-u-boot-environment-variables-with-correct-def.patch \
    file://0036-fix-SP-address-during-SPL.patch \
    file://0037-Enable-CONFIG_PMUFW_INIT_FILE.patch \
    file://0038-board-ni-zynqmp-create-pm_cfg_obj-output-directory.patch \
    file://0039-board-x410-add-support-for-x410-rev5.patch \
    file://0040-Fix-Set-CONFIG_REMAKE_ELF-to-attach-dtb.patch \
    file://0041-board-ni-zynqmp-fix-overlay-name-format.patch \
    file://0042-Fix-Kernel-6.12-did-NOT-successfully.patch \
    "

DEPENDS += "${@bb.utils.contains('UBOOT_ENV_SUFFIX', 'scr', 'u-boot-mkimage-native', '', d)}"

inherit uboot-config uboot-extlinux-config uboot-sign deploy python3native kernel-arch

DEPENDS += "swig-native"

EXTRA_OEMAKE = 'CROSS_COMPILE=${TARGET_PREFIX} CC="${TARGET_PREFIX}gcc ${TOOLCHAIN_OPTIONS} ${DEBUG_PREFIX_MAP}" V=1'
EXTRA_OEMAKE += 'HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}"'
EXTRA_OEMAKE += 'STAGING_INCDIR=${STAGING_INCDIR_NATIVE} STAGING_LIBDIR=${STAGING_LIBDIR_NATIVE}'

PACKAGECONFIG ??= "openssl"
# u-boot will compile its own tools during the build, with specific
# configurations (aka when CONFIG_FIT_SIGNATURE is enabled) openssl is needed as
# a host build dependency.
PACKAGECONFIG[openssl] = ",,openssl-native"

# Allow setting an additional version string that will be picked up by the
# u-boot build system and appended to the u-boot version.  If the .scmversion
# file already exists it will not be overwritten.
UBOOT_LOCALVERSION ?= ""

# Default name of u-boot initial env, but enable individual recipes to change
# this value.
UBOOT_INITIAL_ENV ?= "${PN}-initial-env"

require u-boot-configure-2026.01.inc

UBOOT_ELF:aarch64 = "u-boot"

# Output the ELF generated. Some platforms can use the ELF file and directly
# load it (JTAG booting, QEMU) additionally the ELF can be used for debugging
# purposes.
UBOOT_ELF_SUFFIX ?= "elf"
UBOOT_ELF_IMAGE ?= "u-boot-${MACHINE}-${PV}-${PR}.${UBOOT_ELF_SUFFIX}"
UBOOT_ELF_BINARY ?= "u-boot.${UBOOT_ELF_SUFFIX}"
UBOOT_ELF_SYMLINK ?= "u-boot-${MACHINE}.${UBOOT_ELF_SUFFIX}"

do_savedefconfig() {
	bbplain "Saving defconfig to:\n${B}/defconfig"
	oe_runmake -C ${B} savedefconfig
}
do_savedefconfig[nostamp] = "1"
addtask savedefconfig after do_configure
UBOOT_ARCH_DIR = "${@'arm' if d.getVar('UBOOT_ARCH').startswith('arm') else d.getVar('UBOOT_ARCH')}"
do_compile () {
    if [ "${@bb.utils.filter('DISTRO_FEATURES', 'ld-is-gold', d)}" ]; then
        sed -i 's/$(CROSS_COMPILE)ld$/$(CROSS_COMPILE)ld.bfd/g' ${S}/config.mk
    fi

    unset LDFLAGS
    unset CFLAGS
    unset CPPFLAGS

    if [ ! -e ${B}/.scmversion -a ! -e ${S}/.scmversion ]
    then
        echo ${UBOOT_LOCALVERSION} > ${B}/.scmversion
        echo ${UBOOT_LOCALVERSION} > ${S}/.scmversion
    fi

    if [ -n "${UBOOT_CONFIG}" -o -n "${UBOOT_DELTA_CONFIG}" ]
    then
        unset i j
        for config in ${UBOOT_MACHINE}; do
            i=$(expr $i + 1);
            for type in ${UBOOT_CONFIG}; do
                j=$(expr $j + 1);
                if [ $j -eq $i ]
                then
                    uboot_compile_config $i $config $type
                fi
            done
            unset j
        done
        unset i
    else
        uboot_compile
    fi

    if [ -n "${UBOOT_ENV}" ] && [ "${UBOOT_ENV_SUFFIX}" = "scr" ]
    then
        ${UBOOT_MKIMAGE} -C none -A ${UBOOT_ARCH} -T script -d ${WORKDIR}/${UBOOT_ENV_SRC} ${WORKDIR}/${UBOOT_ENV_BINARY}
    fi
}

uboot_compile_config () {
    i=$1
    config=$2
    type=$3

    oe_runmake -C ${S} O=${B}/${config} ${UBOOT_MAKE_TARGET}

    unset k
    for binary in ${UBOOT_BINARIES}; do
        k=$(expr $k + 1);
        if [ $k -eq $i ]; then
            uboot_compile_config_copy_binary $config $type $binary
        fi
    done
    unset k

    # Generate the uboot-initial-env
    if [ -n "${UBOOT_INITIAL_ENV}" ]; then
        oe_runmake -C ${S} O=${B}/${config} u-boot-initial-env
        cp ${B}/${config}/u-boot-initial-env ${B}/${config}/u-boot-initial-env-${type}
    fi
}

uboot_compile_config_copy_binary () {
    config=$1
    type=$2
    binary=$3

    cp ${B}/${config}/${binary} ${B}/${config}/${UBOOT_BINARYNAME}-${type}.${UBOOT_SUFFIX}
}

uboot_compile () {
    oe_runmake -C ${S} O=${B} ${UBOOT_MAKE_TARGET}

    # Generate the uboot-initial-env
    if [ -n "${UBOOT_INITIAL_ENV}" ]; then
        oe_runmake -C ${S} O=${B} u-boot-initial-env
    fi
}

do_install () {
    if [ -n "${UBOOT_CONFIG}" ]
    then
        for config in ${UBOOT_MACHINE}; do
            i=$(expr $i + 1);
            for type in ${UBOOT_CONFIG}; do
                j=$(expr $j + 1);
                if [ $j -eq $i ]
                then
                    uboot_install_config $config $type
                fi
            done
            unset j
        done
        unset i
    else
        uboot_install
    fi

    if [ -n "${UBOOT_ELF}" ]
    then
        if [ -n "${UBOOT_CONFIG}" ]
        then
            for config in ${UBOOT_MACHINE}; do
                i=$(expr $i + 1);
                for type in ${UBOOT_CONFIG}; do
                    j=$(expr $j + 1);
                    if [ $j -eq $i ]
                    then
                        uboot_install_elf_config $config $type
                    fi
                done
                unset j
            done
            unset i
        else
            uboot_install_elf
        fi
    fi

    if [ -e ${WORKDIR}/fw_env.config ] ; then
        install -d ${D}${sysconfdir}
        install -m 644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
    fi

    if [ -n "${SPL_BINARY}" ]
    then
        if [ -n "${UBOOT_CONFIG}" ]
        then
            for config in ${UBOOT_MACHINE}; do
                i=$(expr $i + 1);
                for type in ${UBOOT_CONFIG}; do
                    j=$(expr $j + 1);
                    if [ $j -eq $i ]
                    then
                        uboot_install_spl_config $config $type
                    fi
                done
                unset j
            done
            unset i
        else
            uboot_install_spl
        fi
    fi

    if [ -n "${UBOOT_ENV}" ]
    then
        install -m 644 ${WORKDIR}/${UBOOT_ENV_BINARY} ${D}/boot/${UBOOT_ENV_IMAGE}
        ln -sf ${UBOOT_ENV_IMAGE} ${D}/boot/${UBOOT_ENV_BINARY}
    fi

    if [ "${UBOOT_EXTLINUX}" = "1" ]
    then
        install -Dm 0644 ${UBOOT_EXTLINUX_CONFIG} ${D}/${UBOOT_EXTLINUX_INSTALL_DIR}/${UBOOT_EXTLINUX_CONF_NAME}
    fi
}

uboot_install_config () {
    config=$1
    type=$2

    install -D -m 644 ${B}/${config}/${UBOOT_BINARYNAME}-${type}.${UBOOT_SUFFIX} ${D}/boot/${UBOOT_BINARYNAME}-${type}-${UBOOT_VERSION}.${UBOOT_SUFFIX}
    ln -sf ${UBOOT_BINARYNAME}-${type}-${UBOOT_VERSION}.${UBOOT_SUFFIX} ${D}/boot/${UBOOT_BINARY}-${type}
    ln -sf ${UBOOT_BINARYNAME}-${type}-${UBOOT_VERSION}.${UBOOT_SUFFIX} ${D}/boot/${UBOOT_BINARY}

    # Install the uboot-initial-env
    if [ -n "${UBOOT_INITIAL_ENV}" ]; then
        install -D -m 644 ${B}/${config}/u-boot-initial-env-${type} ${D}/${sysconfdir}/${UBOOT_INITIAL_ENV}-${MACHINE}-${type}-${UBOOT_VERSION}
        ln -sf ${UBOOT_INITIAL_ENV}-${MACHINE}-${type}-${UBOOT_VERSION} ${D}/${sysconfdir}/${UBOOT_INITIAL_ENV}-${MACHINE}-${type}
        ln -sf ${UBOOT_INITIAL_ENV}-${MACHINE}-${type}-${UBOOT_VERSION} ${D}/${sysconfdir}/${UBOOT_INITIAL_ENV}-${type}
        ln -sf ${UBOOT_INITIAL_ENV}-${MACHINE}-${type}-${UBOOT_VERSION} ${D}/${sysconfdir}/${UBOOT_INITIAL_ENV}
    fi
}

uboot_install () {
    install -D -m 644 ${B}/${UBOOT_BINARY} ${D}/boot/${UBOOT_IMAGE}
    ln -sf ${UBOOT_IMAGE} ${D}/boot/${UBOOT_BINARY}

    # Install the uboot-initial-env
    if [ -n "${UBOOT_INITIAL_ENV}" ]; then
        install -D -m 644 ${B}/u-boot-initial-env ${D}/${sysconfdir}/${UBOOT_INITIAL_ENV}-${MACHINE}-${UBOOT_VERSION}
        ln -sf ${UBOOT_INITIAL_ENV}-${MACHINE}-${UBOOT_VERSION} ${D}/${sysconfdir}/${UBOOT_INITIAL_ENV}-${MACHINE}
        ln -sf ${UBOOT_INITIAL_ENV}-${MACHINE}-${UBOOT_VERSION} ${D}/${sysconfdir}/${UBOOT_INITIAL_ENV}
    fi
}

uboot_install_elf_config () {
    config=$1
    type=$2

    install -m 644 ${B}/${config}/${UBOOT_ELF} ${D}/boot/u-boot-${type}-${UBOOT_VERSION}.${UBOOT_ELF_SUFFIX}
    ln -sf u-boot-${type}-${UBOOT_VERSION}.${UBOOT_ELF_SUFFIX} ${D}/boot/${UBOOT_BINARY}-${type}
    ln -sf u-boot-${type}-${UBOOT_VERSION}.${UBOOT_ELF_SUFFIX} ${D}/boot/${UBOOT_BINARY}
}

uboot_install_elf () {
    install -m 644 ${B}/${UBOOT_ELF} ${D}/boot/${UBOOT_ELF_IMAGE}
    ln -sf ${UBOOT_ELF_IMAGE} ${D}/boot/${UBOOT_ELF_BINARY}
}

uboot_install_spl_config () {
    config=$1
    type=$2

    install -m 644 ${B}/${config}/${SPL_BINARY} ${D}/boot/${SPL_BINARYNAME}-${type}-${UBOOT_VERSION}${SPL_DELIMITER}${SPL_SUFFIX}
    ln -sf ${SPL_BINARYNAME}-${type}-${UBOOT_VERSION}${SPL_DELIMITER}${SPL_SUFFIX} ${D}/boot/${SPL_BINARYFILE}-${type}
    ln -sf ${SPL_BINARYNAME}-${type}-${UBOOT_VERSION}${SPL_DELIMITER}${SPL_SUFFIX} ${D}/boot/${SPL_BINARYFILE}
}

uboot_install_spl () {
    install -m 644 ${B}/${SPL_BINARY} ${D}/boot/${SPL_IMAGE}
    ln -sf ${SPL_IMAGE} ${D}/boot/${SPL_BINARYFILE}
}

PACKAGE_BEFORE_PN += "${PN}-env ${PN}-extlinux"

RPROVIDES:${PN}-env += "u-boot-default-env"
ALLOW_EMPTY:${PN}-env = "1"
FILES:${PN}-env = " \
    ${@ '${sysconfdir}/${UBOOT_INITIAL_ENV}*' if d.getVar('UBOOT_INITIAL_ENV') else ''} \
    ${sysconfdir}/fw_env.config \
"

FILES:${PN}-extlinux = "${UBOOT_EXTLINUX_INSTALL_DIR}/${UBOOT_EXTLINUX_CONF_NAME}"
RDEPENDS:${PN} += "${@bb.utils.contains('UBOOT_EXTLINUX', '1', '${PN}-extlinux', '', d)}"

SYSROOT_DIRS += "/boot"
FILES:${PN} = "/boot ${datadir}"
RDEPENDS:${PN} += "${PN}-env"

do_deploy () {
    if [ -n "${UBOOT_CONFIG}" ]
    then
        for config in ${UBOOT_MACHINE}; do
            i=$(expr $i + 1);
            for type in ${UBOOT_CONFIG}; do
                j=$(expr $j + 1);
                if [ $j -eq $i ]
                then
                    uboot_deploy_config $config $type
                fi
            done
            unset j
        done
        unset i
    else
        uboot_deploy
    fi

    if [ -e ${WORKDIR}/fw_env.config ] ; then
        install -D -m 644 ${WORKDIR}/fw_env.config ${DEPLOYDIR}/fw_env.config-${MACHINE}-${UBOOT_VERSION}
        cd ${DEPLOYDIR}
        ln -sf fw_env.config-${MACHINE}-${UBOOT_VERSION} fw_env.config-${MACHINE}
        ln -sf fw_env.config-${MACHINE}-${UBOOT_VERSION} fw_env.config
    fi

    if [ -n "${UBOOT_ELF}" ]
    then
        if [ -n "${UBOOT_CONFIG}" ]
        then
            for config in ${UBOOT_MACHINE}; do
                i=$(expr $i + 1);
                for type in ${UBOOT_CONFIG}; do
                    j=$(expr $j + 1);
                    if [ $j -eq $i ]
                    then
                        uboot_deploy_elf_config $config $type
                    fi
                done
                unset j
            done
            unset i
        else
            uboot_deploy_elf
        fi
    fi


     if [ -n "${SPL_BINARY}" ]
     then
        if [ -n "${UBOOT_CONFIG}" ]
        then
            for config in ${UBOOT_MACHINE}; do
                i=$(expr $i + 1);
                for type in ${UBOOT_CONFIG}; do
                    j=$(expr $j + 1);
                    if [ $j -eq $i ]
                    then
                        uboot_deploy_spl_config $config $type
                    fi
                done
                unset j
            done
            unset i
        else
            uboot_deploy_spl
        fi
    fi

    if [ -n "${UBOOT_ENV}" ]
    then
        install -m 644 ${WORKDIR}/${UBOOT_ENV_BINARY} ${DEPLOYDIR}/${UBOOT_ENV_IMAGE}
        ln -sf ${UBOOT_ENV_IMAGE} ${DEPLOYDIR}/${UBOOT_ENV_BINARY}
        ln -sf ${UBOOT_ENV_IMAGE} ${DEPLOYDIR}/${UBOOT_ENV_SYMLINK}
    fi

    if [ "${UBOOT_EXTLINUX}" = "1" ]
    then
        install -m 644 ${UBOOT_EXTLINUX_CONFIG} ${DEPLOYDIR}/${UBOOT_EXTLINUX_SYMLINK}
        ln -sf ${UBOOT_EXTLINUX_SYMLINK} ${DEPLOYDIR}/${UBOOT_EXTLINUX_CONF_NAME}-${MACHINE}
        ln -sf ${UBOOT_EXTLINUX_SYMLINK} ${DEPLOYDIR}/${UBOOT_EXTLINUX_CONF_NAME}
    fi

    if [ -n "${UBOOT_DTB}" ]
    then
        install -m 644 ${B}/arch/${UBOOT_ARCH_DIR}/dts/${UBOOT_DTB_BINARY} ${DEPLOYDIR}/
    fi
}

uboot_deploy_config () {
    config=$1
    type=$2

    install -D -m 644 ${B}/${config}/${UBOOT_BINARYNAME}-${type}.${UBOOT_SUFFIX} ${DEPLOYDIR}/${UBOOT_BINARYNAME}-${type}-${UBOOT_VERSION}.${UBOOT_SUFFIX}
    cd ${DEPLOYDIR}
    ln -sf ${UBOOT_BINARYNAME}-${type}-${UBOOT_VERSION}.${UBOOT_SUFFIX} ${UBOOT_SYMLINK}-${type}
    ln -sf ${UBOOT_BINARYNAME}-${type}-${UBOOT_VERSION}.${UBOOT_SUFFIX} ${UBOOT_SYMLINK}
    ln -sf ${UBOOT_BINARYNAME}-${type}-${UBOOT_VERSION}.${UBOOT_SUFFIX} ${UBOOT_BINARY}-${type}
    ln -sf ${UBOOT_BINARYNAME}-${type}-${UBOOT_VERSION}.${UBOOT_SUFFIX} ${UBOOT_BINARY}

    # Deploy the uboot-initial-env
    if [ -n "${UBOOT_INITIAL_ENV}" ]; then
        install -D -m 644 ${B}/${config}/u-boot-initial-env-${type} ${DEPLOYDIR}/${UBOOT_INITIAL_ENV}-${MACHINE}-${type}-${UBOOT_VERSION}
        cd ${DEPLOYDIR}
        ln -sf ${UBOOT_INITIAL_ENV}-${MACHINE}-${type}-${UBOOT_VERSION} ${UBOOT_INITIAL_ENV}-${MACHINE}-${type}
        ln -sf ${UBOOT_INITIAL_ENV}-${MACHINE}-${type}-${UBOOT_VERSION} ${UBOOT_INITIAL_ENV}-${type}
    fi
}

uboot_deploy () {
    install -D -m 644 ${B}/${UBOOT_BINARY} ${DEPLOYDIR}/${UBOOT_IMAGE}

    cd ${DEPLOYDIR}
    rm -f ${UBOOT_BINARY} ${UBOOT_SYMLINK}
    ln -sf ${UBOOT_IMAGE} ${UBOOT_SYMLINK}
    ln -sf ${UBOOT_IMAGE} ${UBOOT_BINARY}

    # Deploy the uboot-initial-env
    if [ -n "${UBOOT_INITIAL_ENV}" ]; then
        install -D -m 644 ${B}/u-boot-initial-env ${DEPLOYDIR}/${UBOOT_INITIAL_ENV}-${MACHINE}-${UBOOT_VERSION}
        cd ${DEPLOYDIR}
        ln -sf ${UBOOT_INITIAL_ENV}-${MACHINE}-${UBOOT_VERSION} ${UBOOT_INITIAL_ENV}-${MACHINE}
        ln -sf ${UBOOT_INITIAL_ENV}-${MACHINE}-${UBOOT_VERSION} ${UBOOT_INITIAL_ENV}
    fi
}

uboot_deploy_elf_config () {
    config=$1
    type=$2

    install -m 644 ${B}/${config}/${UBOOT_ELF} ${DEPLOYDIR}/u-boot-${type}-${UBOOT_VERSION}.${UBOOT_ELF_SUFFIX}
    ln -sf u-boot-${type}-${UBOOT_VERSION}.${UBOOT_ELF_SUFFIX} ${DEPLOYDIR}/${UBOOT_ELF_BINARY}-${type}
    ln -sf u-boot-${type}-${UBOOT_VERSION}.${UBOOT_ELF_SUFFIX} ${DEPLOYDIR}/${UBOOT_ELF_BINARY}
    ln -sf u-boot-${type}-${UBOOT_VERSION}.${UBOOT_ELF_SUFFIX} ${DEPLOYDIR}/${UBOOT_ELF_SYMLINK}-${type}
    ln -sf u-boot-${type}-${UBOOT_VERSION}.${UBOOT_ELF_SUFFIX} ${DEPLOYDIR}/${UBOOT_ELF_SYMLINK}
}

uboot_deploy_elf () {
    install -m 644 ${B}/${UBOOT_ELF} ${DEPLOYDIR}/${UBOOT_ELF_IMAGE}
    ln -sf ${UBOOT_ELF_IMAGE} ${DEPLOYDIR}/${UBOOT_ELF_BINARY}
    ln -sf ${UBOOT_ELF_IMAGE} ${DEPLOYDIR}/${UBOOT_ELF_SYMLINK}
}

uboot_deploy_spl_config () {
    config=$1
    type=$2

    install -m 644 ${B}/${config}/${SPL_BINARY} ${DEPLOYDIR}/${SPL_BINARYNAME}-${type}-${UBOOT_VERSION}${SPL_DELIMITER}${SPL_SUFFIX}
    rm -f ${DEPLOYDIR}/${SPL_BINARYFILE} ${DEPLOYDIR}/${SPL_SYMLINK}
    ln -sf ${SPL_BINARYNAME}-${type}-${UBOOT_VERSION}${SPL_DELIMITER}${SPL_SUFFIX} ${DEPLOYDIR}/${SPL_BINARYFILE}-${type}
    ln -sf ${SPL_BINARYNAME}-${type}-${UBOOT_VERSION}${SPL_DELIMITER}${SPL_SUFFIX} ${DEPLOYDIR}/${SPL_BINARYFILE}
    ln -sf ${SPL_BINARYNAME}-${type}-${UBOOT_VERSION}${SPL_DELIMITER}${SPL_SUFFIX} ${DEPLOYDIR}/${SPL_SYMLINK}-${type}
    ln -sf ${SPL_BINARYNAME}-${type}-${UBOOT_VERSION}${SPL_DELIMITER}${SPL_SUFFIX} ${DEPLOYDIR}/${SPL_SYMLINK}
}

uboot_deploy_spl () {
    install -m 644 ${B}/${SPL_BINARY} ${DEPLOYDIR}/${SPL_IMAGE}
    ln -sf ${SPL_IMAGE} ${DEPLOYDIR}/${SPL_BINARYNAME}
    ln -sf ${SPL_IMAGE} ${DEPLOYDIR}/${SPL_SYMLINK}
}

DEPENDS:append:ni-titanium = " zip-native"

FILES:${PN}:ni-titanium="/uboot /etc"

PMU_FIRMWARE_DEPLOY_DIR:ni-titanium = "${BINARYDIR}/ni-titanium"
PMU_FIRMWARE_IMAGE_NAME:ni-titanium = "pmu-firmware"

do_compile[depends] += "virtual/arm-trusted-firmware:do_deploy"

EXTRA_OEMAKE:append:ni-titanium = " CONFIG_PMUFW_INIT_FILE=${PMU_FIRMWARE_DEPLOY_DIR}/${PMU_FIRMWARE_IMAGE_NAME}.bin"
# BL31 is passed to binman via 'binman -a atf-bl31-path=${BL31}' in the U-Boot
# Makefile. Without this, binman produces a zero-size ATF entry in the FIT image.
EXTRA_OEMAKE:append:ni-titanium = " BL31=${B}/bl31.bin"
# Add Python include directory to HOSTCFLAGS for building pylibfdt
EXTRA_OEMAKE:append:ni-titanium = " HOSTCFLAGS='${BUILD_CFLAGS} -I${STAGING_INCDIR_NATIVE}/python3.12'"

do_compile:prepend:ni-titanium() {
    # load some variables from the config file
    UBOOT_CONFIGFILE="${S}/configs/${UBOOT_MACHINE}"
    grep -e "^CONFIG_SPL_FIT_SOURCE=" \
      ${UBOOT_CONFIGFILE} > ${B}/config.temp || true
    . ${B}/config.temp
    # copy ARM Trusted firmware Image: EL3 Runtime Firmware: AP_BL31
    # see https://github.com/ARM-software/arm-trusted-firmware/blob/master/docs/getting_started/image-terminology.rst
    cp ${DEPLOY_DIR_IMAGE}/arm-trusted-firmware.bin ${B}/bl31.bin
    cp ${DEPLOY_DIR_IMAGE}/arm-trusted-firmware.elf ${B}/bl31.elf
    # reference/copy Platform Management Unit (PMU) Firmware
    # see https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841724/PMU+Firmware
    # note: u-boot-spl-zynq-init.inc from meta-xilinx sets CONFIG_PMUFW_INIT_FILE
    # as EXTRA_OEMAKE option
    echo "using CONFIG_PMUFW_INIT_FILE=${PMU_FIRMWARE_DEPLOY_DIR}/${PMU_FIRMWARE_IMAGE_NAME}.bin"
    cp ${PMU_FIRMWARE_DEPLOY_DIR}/${PMU_FIRMWARE_IMAGE_NAME}.elf \
      ${B}/pmu-firmware.elf
    # copy the CONFIG_SPL_FIT_SOURCE file from the source to the build directory
    # where the Makefile expects it (only if CONFIG_SPL_FIT_SOURCE is defined)
    if [ -n "${CONFIG_SPL_FIT_SOURCE}" ]; then
        mkdir -p $(dirname ${B}/${CONFIG_SPL_FIT_SOURCE})
        cp ${S}/${CONFIG_SPL_FIT_SOURCE} \
          ${B}/${CONFIG_SPL_FIT_SOURCE}
    fi
}

do_install:append:ni-titanium() {
    mv ${D}/boot ${D}/uboot
}

CROS_EC_DEPLOY_DIR_IMAGE:ni-titanium ?= "${TOPDIR}/tmp-stm32-baremetal/deploy/images/ni-titanium-ec-rev5"
python __anonymous() {
    if "ni-titanium-ec" in (d.getVar('BBMULTICONFIG') or "").split(' '):
        d.appendVarFlag('do_deploy', 'mcdepends', ' mc:ni-titanium:ni-titanium-ec:chromium-ec:do_deploy')
}

do_deploy:append:ni-titanium() {
  # prepare a zip file which includes all necessary files for loading u-boot
  # via JTAG
  UBOOT_JTAG_FILES_TARGET=u-boot-jtag-files-${MACHINE}-${PV}.zip
  UBOOT_JTAG_FILES_SYMLINK1=u-boot-jtag-files-${MACHINE}.zip
  UBOOT_JTAG_FILES_SYMLINK2=u-boot-jtag-files.zip

  # Create a symlink to rename u-boot as u-boot.elf for the zip
  # Only add EC files if they exist
  if ls ${CROS_EC_DEPLOY_DIR_IMAGE}/ec-titanium-rev*.bin 1>/dev/null 2>&1; then
    zip -j -MM ${DEPLOYDIR}/${UBOOT_JTAG_FILES_TARGET} \
      ${WORKDIR}/boot_u-boot ${WORKDIR}/boot_u-boot.tcl ${B}/pmu-firmware.elf \
      ${B}/spl/u-boot-spl.bin ${B}/bl31.elf ${B}/u-boot.elf \
      ${CROS_EC_DEPLOY_DIR_IMAGE}/ec-titanium-rev*.bin
  else
    bbnote "EC firmware not found, building JTAG zip without EC files"
    zip -j -MM ${DEPLOYDIR}/${UBOOT_JTAG_FILES_TARGET} \
      ${WORKDIR}/boot_u-boot ${WORKDIR}/boot_u-boot.tcl ${B}/pmu-firmware.elf \
      ${B}/spl/u-boot-spl.bin ${B}/bl31.elf ${B}/u-boot.elf
  fi

  ln -sf ${UBOOT_JTAG_FILES_TARGET} ${DEPLOYDIR}/${UBOOT_JTAG_FILES_SYMLINK1}
  ln -sf ${UBOOT_JTAG_FILES_TARGET} ${DEPLOYDIR}/${UBOOT_JTAG_FILES_SYMLINK2}
}

# workarounds to remove the zynqmp-overrides to u-boot because the platform init
# and the PMU firmware are already taken care of by the ni-titanium overrides
DEPENDS:remove:ni-titanium = " virtual/xilinx-platform-init"

do_zynq_platform_init:ni-titanium() {
}

addtask deploy before do_build after do_compile
