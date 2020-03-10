# Include the nirio.h header in the sysroot and final package
# TODO: Investigate using https://bugzilla.yoctoproject.org/show_bug.cgi?id=5305 instead

PACKAGES_append = " ${KERNEL_PACKAGE_NAME}-headers"
FILES_${KERNEL_PACKAGE_NAME}-headers += "${exec_prefix}/include/misc/nirio.h"

do_install_append () {
	install -d ${D}${exec_prefix}/include/misc
	find ${STAGING_KERNEL_DIR}/ -name nirio.h -exec cp {} ${D}${exec_prefix}/include/misc \;
}

sysroot_stage_all_append () {
	sysroot_stage_dir ${D}${exec_prefix}/include ${SYSROOT_DESTDIR}${exec_prefix}/include
}
