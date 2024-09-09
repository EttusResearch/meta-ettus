# Busybox's bzip2 implementation is slow, so include pbzip2 (which also supports
# parallel decompression using multiple cores). bmaptool will automatically use
# pbzip2 if it's installed. This significantly speeds up SD or eMMC flashing.
RRECOMMENDS:${PN} += "pbzip2"
