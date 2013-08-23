FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-xlnx/${MACHINE}:"

SRC_URI_append_ettus-e200 = " file://fsbl.elf.bz2 \
                               file://uEnv.txt \
                             "
