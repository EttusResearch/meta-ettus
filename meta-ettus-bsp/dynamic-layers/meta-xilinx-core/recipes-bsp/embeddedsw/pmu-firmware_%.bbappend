include libstdc-preload.inc

# see https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841724/PMU+Firmware#PMU-FW-Build-Flags
#
# Enable escalation of errors to system reset:
# -DENABLE_EM -DENABLE_SCHEDULER -DENABLE_PM -DENABLE_RECOVERY -DENABLE_ESCALATION
#
# Make system reset work with NI titanium board:
# -DBOARD_SHUTDOWN_PIN=2 -DBOARD_SHUTDOWN_PIN_STATE=0
#
# Escalate error to system reset immediately without restarting the watchdog timer
# and waiting the configured watchdog time again (e.g. 60s watchdog time configured
# in U-Boot or Linux: system reset is triggered after 120s when flag is not set).
# -DCHECK_HEALTHY_BOOT_VAL=1
#
# Display errors and warnings:
# -DPM_LOG_LEVEL=3


YAML_COMPILER_FLAGS:ni-titanium = " \
    -DENABLE_EM -DENABLE_SCHEDULER -DENABLE_PM -DENABLE_RECOVERY -DENABLE_ESCALATION \
    -DBOARD_SHUTDOWN_PIN=2 -DBOARD_SHUTDOWN_PIN_STATE=0 \
    -DCHECK_HEALTHY_BOOT_VAL=1 \
    -DPM_LOG_LEVEL=3 \
    "
