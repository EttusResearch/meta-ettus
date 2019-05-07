SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=master \
          "
SRCREV = "2f7f7c8d2d5d0bebd84618077e61e344c689f622"

python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
