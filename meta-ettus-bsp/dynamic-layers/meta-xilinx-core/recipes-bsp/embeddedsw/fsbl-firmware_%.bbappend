include libstdc-preload.inc

# see https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842019/Zynq+UltraScale+FSBL

# Explanation of changed compiler flags:
#
# FSBL_UNPROVISIONED_AUTH_SIGN_EXCLUDE_VAL
#   This flag controls whether auth signing should be checked on
#   unprovisioned devices. We set this to zero so the check is only
#   executed on provisioned devices. This allows us to use the same
#   signed boot binaries on both device types.
#
# FSBL_USB_EXCLUDE_VAL
#   Setting this flag to zero allows us to use ZynqMP's USB boot
#   mechanism.
#
# FSBL_NAND_EXCLUDE_VAL/FSBL_QSPI_EXCLUDE_VAL
#   We currently support neither booting via NAND nor via QSPI so
#   we disable this here to save space for the FSBL binary.
#
# FSBL_DEBUG_VAL
#   Enable print of general errors and information
#
# FSBL_DEBUG_INFO_VAL
#   Enable print of more detailed messages

YAML_COMPILER_FLAGS:ni-titanium = " \
    -DFSBL_UNPROVISIONED_AUTH_SIGN_EXCLUDE_VAL=0 \
    -DFSBL_USB_EXCLUDE_VAL=0 \
    -DFSBL_NAND_EXCLUDE_VAL=1 \
    -DFSBL_QSPI_EXCLUDE_VAL=1 \
    -DFSBL_DEBUG_VAL=1 \
    -DFSBL_DEBUG_INFO_VAL=1 \
    "

# BSP compiler flags to minimize FSBL size
# -g0                                 no debug symbols
# -Wall                               all compiler warnings
# -Wextra                             even more warnings
# -fno-tree-loop-distribute-patterns  Advised by Xilinx for optimized code with newer gcc versions (10.2+)
#                                     Might otherwise lead to unaligned access.
# -Os                                 Optimize for size.
# -flto                               Optimize when linking - allows for cross source optimization
# -ffat-lto-objects                   Allows Linker to choose between LTO or traditional object code
#                                     during link optimization.

YAML_BSP_COMPILER_FLAGS:ni-titanium = "-g0 -Wall -Wextra -fno-tree-loop-distribute-patterns -Os -flto -ffat-lto-objects"
