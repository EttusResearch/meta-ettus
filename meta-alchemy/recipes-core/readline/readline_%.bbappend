# use custom inputrc file when building for the target
# (but not when building for the native host)
FILESEXTRAPATHS_prepend_class-target := "${THISDIR}/files:"
