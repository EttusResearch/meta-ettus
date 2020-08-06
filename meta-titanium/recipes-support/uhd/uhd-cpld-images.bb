deltask do_fetch
deltask do_unpack
deltask do_patch
deltask do_configure
deltask do_compile
deltask do_populate_sysroot

LICENSE = "LGPLv3+"

FILES_${PN} = " \
    /lib/firmware/ni/cpld-titanium.* \
    /lib/firmware/ni/cpld-zirconium.* \
    "

MB_CPLD_SUBDIRECTORY ?= ""
ZBX_CPLD_SUBDIRECTORY ?= ""

do_install() {
    install -d "${D}/lib/firmware/ni"
    install -D "${S}/${MB_CPLD_SUBDIRECTORY}/mb_cpld.rpd" "${D}/lib/firmware/ni/cpld-titanium.rpd"
    install -D "${S}/${MB_CPLD_SUBDIRECTORY}/mb_cpld_isp_on.svf" "${D}/lib/firmware/ni/cpld-titanium.svf"
    install -D "${S}/${ZBX_CPLD_SUBDIRECTORY}/zr_top_cpld.rpd" "${D}/lib/firmware/ni/cpld-zirconium.rpd"
    install -D "${S}/${ZBX_CPLD_SUBDIRECTORY}/zr_top_cpld_isp_off.svf" "${D}/lib/firmware/ni/cpld-zirconium.svf"
}
