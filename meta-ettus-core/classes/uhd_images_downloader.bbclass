DEPENDS += "uhd python3-native python3-requests-native python3-urllib3-native python3-chardet-native python3-six-native python3-certifi-native python3-idna-native"

inherit python3native

# set the UHD images you want to download
UHD_IMAGES_TO_DOWNLOAD ??= ""
UHD_IMAGES_DOWNLOAD_DIR ??= "${S}"
UHD_BASE_URL ??= ""

addtask do_download_uhd_images after do_unpack do_prepare_recipe_sysroot before do_compile

do_download_uhd_images() {
    if [ -n "${EXTERNALSRC}" ]; then
        bbwarn "building from external source - skip downloading UHD FPGA images"
        return
    fi
    DOWNLOADER="python3 ${WORKDIR}/recipe-sysroot/usr/lib/uhd/utils/uhd_images_downloader.py"
    DOWNLOADER_OPTS="-i ${UHD_IMAGES_DOWNLOAD_DIR}"
    if [ -n "${UHD_BASE_URL}" ]; then
        DOWNLOADER_OPTS="$DOWNLOADER_OPTS -b ${UHD_BASE_URL}"
    fi
    mkdir -p ${UHD_IMAGES_DOWNLOAD_DIR}
    for type in ${UHD_IMAGES_TO_DOWNLOAD}; do
        $DOWNLOADER $DOWNLOADER_OPTS -t "$type"
    done
}
