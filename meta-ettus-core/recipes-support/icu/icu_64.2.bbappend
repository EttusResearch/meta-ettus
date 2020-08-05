# apply changes of commit c90113c61877b35211878286cd3b60a36b8c8684 to oe-core,
# branch zeus (in case an older src-hash of the oe-core layer is used)
#
# Subject: icu: update SRC_URI
#
# New releases of ICU are published on github.
#
# Signed-off-by: Alexander Kanavin <alex.kanavin@gmail.com>
# Signed-off-by: Richard Purdie <richard.purdie@linuxfoundation.org>
# Signed-off-by: Anuj Mittal <anuj.mittal@intel.com>

def icu_download_folder(d):
    pvsplit = d.getVar('PV').split('.')
    return pvsplit[0] + "-" + pvsplit[1]

ICU_FOLDER = "${@icu_download_folder(d)}"

BASE_SRC_URI = "https://github.com/unicode-org/icu/releases/download/release-${ICU_FOLDER}/icu4c-${ICU_PV}-src.tgz"

UPSTREAM_CHECK_REGEX = "icu4c-(?P<pver>\d+(_\d+)+)-src"
UPSTREAM_CHECK_URI = "https://github.com/unicode-org/icu/releases"
