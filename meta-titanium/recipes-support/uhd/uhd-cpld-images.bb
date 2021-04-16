inherit uhd_images_downloader

LICENSE = "LGPLv3+"

FILES_${PN} = " \
    /lib/firmware/ni/cpld-titanium.* \
    /lib/firmware/ni/cpld-zirconium.* \
    "

UHD_IMAGES_TO_DOWNLOAD_ni-titanium ?= " \
    ${@ '' if d.getVar('EXTERNALSRC') else 'x4xx_x410_cpld_default'} \
    ${@ '' if d.getVar('EXTERNALSRC') else 'x4xx_zbx_cpld_default'} \
    "

MB_CPLD_SUBDIRECTORY ?= ""
ZBX_CPLD_SUBDIRECTORY ?= ""

do_install() {
    install -d "${D}/lib/firmware/ni"
    install -D "${S}/${MB_CPLD_SUBDIRECTORY}/x4xx_x410_cpld_default.rpd" "${D}/lib/firmware/ni/cpld-titanium.rpd"
    install -D "${S}/${MB_CPLD_SUBDIRECTORY}/x4xx_x410_cpld_default.svf" "${D}/lib/firmware/ni/cpld-titanium.svf"
    install -D "${S}/${ZBX_CPLD_SUBDIRECTORY}/x4xx_zbx_cpld_default.rpd" "${D}/lib/firmware/ni/cpld-zirconium.rpd"
    install -D "${S}/${ZBX_CPLD_SUBDIRECTORY}/x4xx_zbx_cpld_default.svf" "${D}/lib/firmware/ni/cpld-zirconium.svf"
}
