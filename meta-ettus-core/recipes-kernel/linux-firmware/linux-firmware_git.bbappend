FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
                   file://fpga_bit_to_bin.py \
                 "
