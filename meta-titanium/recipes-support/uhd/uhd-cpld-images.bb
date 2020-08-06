inherit uhd_images_downloader

LICENSE = "LGPLv3+"

FILES_${PN} = " \
    /lib/firmware/ni/cpld-x410.* \
    /lib/firmware/ni/cpld-zbx.* \
    "

UHD_IMAGES_TO_DOWNLOAD_ni-titanium ?= " \
    ${@ '' if d.getVar('EXTERNALSRC') else 'x4xx_x410_cpld_default'} \
    ${@ '' if d.getVar('EXTERNALSRC') else 'x4xx_zbx_cpld_default'} \
    "

MB_CPLD_SUBDIRECTORY ?= ""
ZBX_CPLD_SUBDIRECTORY ?= ""

do_install() {
    install -d "${D}/lib/firmware/ni"
    install -D "${S}/${MB_CPLD_SUBDIRECTORY}/usrp_x410_cpld.rpd" "${D}/lib/firmware/ni/cpld-x410.rpd"
    install -D "${S}/${MB_CPLD_SUBDIRECTORY}/usrp_x410_cpld.svf" "${D}/lib/firmware/ni/cpld-x410.svf"
    install -D "${S}/${ZBX_CPLD_SUBDIRECTORY}/usrp_zbx_cpld.rpd" "${D}/lib/firmware/ni/cpld-zbx.rpd"
    install -D "${S}/${ZBX_CPLD_SUBDIRECTORY}/usrp_zbx_cpld.svf" "${D}/lib/firmware/ni/cpld-zbx.svf"
}
