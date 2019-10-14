SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=master \
          "
SRCREV = "0408f47b23a834192a31d8000bd5e2536704728e"

python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
