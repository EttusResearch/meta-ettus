SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=master \
          "
SRCREV = "6563c53743617215a18542db7d7050a04a0d409d"

python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
