FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE:ni-sulfur-ec = "ni-sulfur-ec"
CROS_EC_BOARD:ni-sulfur-ec = "sulfur"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI:ni-sulfur-ec = " \
           git://chromium.googlesource.com/chromiumos/platform/ec;protocol=https;branch=main \
           file://0001-drivers-temp_sensor-Add-TMP431-driver.patch \
           file://0002-sulfur-Initial-support-for-NI-Project-Sulfur-SDR-boa.patch \
           file://0003-sulfur-power-Be-more-careful-with-power-up-sequence.patch \
           file://0004-sulfur-Get-board-revision-from-EEPROM.patch \
           file://0005-sulfur-Enable-CONFIG_FAN_CUSTOM_RPM.patch \
           file://0006-suflur-Re-enable-the-CONFIG_VBOOT_HASH.patch \
           file://0007-sulfur-Add-missing-PWR_CLK_EN-output-GPIO.patch \
           file://0008-sulfur-power-Change-CPRINTS-such-that-they-don-t-end.patch \
           file://0009-sulfur-Measure-fan-speed-using-the-TIM16-TIM17-in-in.patch \
           file://0010-sulfur-Enable-CONFIG_LOW_POWER_IDLE-and-CONFIG_LOW_P.patch \
           file://0011-sulfur-Increase-the-timeouts-to-make-it-work-on-Rev5.patch \
           file://0012-sulfur-changes-to-ec-command-eeinfo.patch \
           file://0013-sulfur-always-reload-EEPROM-info-when-running-ec-com.patch \
           file://0014-sulfur-add-support-for-EEPROM-version-3.patch \
           file://0015-sulfur-apply-Rev5-workaround-for-Rev5-and-not-just-R.patch \
           file://0016-sulfur-prepared-support-for-revJ-rev10.patch \
           file://0017-sulfur-power-fix-reboot-on-powerdown.patch \
           file://0018-sulfur-implementation-adaptions-after-chromium-ec-ma.patch \
           file://0019-board-sulfur-make-rev5-rev10-features-conditional-on.patch \
           file://0020-sulfur-Ensure-fans-are-set-to-auto.patch \
           "

SRCREV:ni-sulfur-ec = "b6411616e99a5564bba0d950fd2728fb7264d9ae"

PATCHTOOL = "git"

LIC_FILES_CHKSUM:ni-sulfur-ec = "file://LICENSE;md5=676b6a95bbfb76c181cdc0edc71c2daf"

do_compile:ni-sulfur-ec() {
    oe_runmake ALLOW_CONFIG=1 BOARD=sulfur-rev5
    oe_runmake ALLOW_CONFIG=1 BOARD=sulfur-rev10
}

do_deploy:ni-sulfur-ec() {
    install -m 0644 ${B}/build/sulfur-rev5/ec.bin ${DEPLOYDIR}/ec-sulfur-rev5.bin
    install -m 0644 ${B}/build/sulfur-rev5/RW/ec.RW.bin ${DEPLOYDIR}/ec-sulfur-rev5.RW.bin
    install -m 0644 ${B}/build/sulfur-rev10/ec.bin ${DEPLOYDIR}/ec-sulfur-rev10.bin
    install -m 0644 ${B}/build/sulfur-rev10/RW/ec.RW.bin ${DEPLOYDIR}/ec-sulfur-rev10.RW.bin
}