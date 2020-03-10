connect

targets -set -nocase -filter {name =~ "PSU"}

# write JTAG security register to disable all security gates
# https://www.xilinx.com/html_docs/registers/ug1087/csu___jtag_sec.html
mwr 0xFFCA0038 0x1FF
after 500

targets -set -filter {name =~ "MicroBlaze PMU"}

# download PMU firmware
dow "pmu-firmware.elf"
con
after 500

targets -set -nocase -filter {name =~ "PSU"}

mwr 0xffff0000 0x14000000

# bring APU 0 out of reset
# https://www.xilinx.com/html_docs/registers/ug1087/crf_apb___rst_fpd_apu.html
mwr 0xfd1a0104 0x380e

targets -set -filter {name =~ "Cortex-A53 #0"}

# download u-boot SPL
dow -data "u-boot-spl.bin" 0xfffc0000
rwr pc 0xfffc0000
after 5000
stop

# download u-boot and ARM trusted firmware
dow "u-boot.elf"
dow "bl31.elf"
con
