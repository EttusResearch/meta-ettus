require recipes-support/uhd/version.inc
require recipes-support/uhd/uhd_git_src.inc
require includes/maintainer-ettus.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

ALLOW_EMPTY_${PN} = "1"

SRC_URI  += " \
    file://LICENSE.md \
"

LICENSE = "LGPLv3+"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE.md;md5=2d2b59b2fc606f13eb2631fb80325865"

addtask check_hashes after do_patch before do_configure

do_check_hashes() {
  cd ${WORKDIR}
  MANIFEST_FILE="git/images/manifest.txt"
  ERROR_OCCURRED=0
  for IMAGE in ${IMAGE_MANIFEST_BINARIES};
  do
    FILE=$(grep -e $IMAGE $MANIFEST_FILE | sed "s|\(\S*\)\s*\(\S*\)\s*\(\S*\)\s*\(\S*\)|\3|")
    URL="http://files.ettus.com/binaries/cache/$FILE"
    SRC_URI_MATCH=$(echo "${SRC_URI}" | grep -e "$URL" || true)
    if [ -n "$SRC_URI_MATCH" ]; then
      FILENAME=$(basename $FILE)
      SHA256SUM=$(grep -e $IMAGE $MANIFEST_FILE | sed "s|\(\S*\)\s*\(\S*\)\s*\(\S*\)\s*\(\S*\)|\4|")
      echo "checking SHA256 checksum of $FILENAME"
      echo "$SHA256SUM  $FILENAME" | sha256sum --check
      unzip -o $FILENAME
    else
      echo "Error: $URL not in SRC_URI"
      OLD_URL=$(echo "${SRC_URI}" | grep -e "http://\S*$IMAGE-[a-z0-9]*\.zip" -o || true)
      if [ -n "$OLD_URL" ]; then
        echo "Please replace $OLD_URL with $URL"
      else
        echo "Please add $URL"
      fi
      ERROR_OCCURRED=1
    fi
  done
  if [ $ERROR_OCCURRED -ne 0 ]; then
    false
  fi
}
