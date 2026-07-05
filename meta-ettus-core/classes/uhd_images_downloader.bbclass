DEPENDS += "uhd-native python3-native python3-requests-native"

inherit python3native

# set the UHD images you want to download
UHD_IMAGES_TO_DOWNLOAD ??= ""
UHD_IMAGES_DOWNLOAD_DIR ??= "${S}"
UHD_BASE_URL ??= ""
UHD_MANIFEST_FILE ??= ""

addtask do_download_uhd_images after do_unpack do_prepare_recipe_sysroot before do_compile

do_download_uhd_images[network] = "1"
do_download_uhd_images() {
    if [ -n "${EXTERNALSRC}" ]; then
        bbwarn "building from external source - skip downloading UHD FPGA images"
        if [ ! -e "${S}/inventory.json" ]; then
            bbwarn "creating empty inventory.json file"
            echo "{}" > ${S}/inventory.json
        fi
    else
        DOWNLOADER="$PYTHON ${STAGING_BINDIR_NATIVE}/uhd_images_downloader"
        DOWNLOADER_OPTS="-i ${UHD_IMAGES_DOWNLOAD_DIR}"
        if [ -n "${UHD_BASE_URL}" ]; then
            DOWNLOADER_OPTS="$DOWNLOADER_OPTS -b ${UHD_BASE_URL}"
        fi
        if [ -n "${UHD_MANIFEST_FILE}" ]; then
            DOWNLOADER_OPTS="$DOWNLOADER_OPTS -m ${UHD_MANIFEST_FILE}"
        fi
        mkdir -p ${UHD_IMAGES_DOWNLOAD_DIR}
        for type in ${UHD_IMAGES_TO_DOWNLOAD}; do
            $DOWNLOADER $DOWNLOADER_OPTS -t "$type"
        done
    fi
}
