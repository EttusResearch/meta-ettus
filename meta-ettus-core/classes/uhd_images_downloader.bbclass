DEPENDS += "uhd"

# set the UHD images you want to download
UHD_IMAGES_TO_DOWNLOAD ??= ""
UHD_IMAGES_DOWNLOAD_DIR ??= "${S}"

addtask do_download_uhd_images after do_prepare_recipe_sysroot before do_compile

do_download_uhd_images() {
    DOWNLOADER="python3 ${WORKDIR}/recipe-sysroot/usr/lib/uhd/utils/uhd_images_downloader.py"
    for type in ${UHD_IMAGES_TO_DOWNLOAD}; do
        $DOWNLOADER -t "$type" -i ${UHD_IMAGES_DOWNLOAD_DIR}
    done
}
