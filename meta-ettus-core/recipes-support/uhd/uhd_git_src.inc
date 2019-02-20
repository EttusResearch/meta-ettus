SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.14"
SRCREV = "62b69494a7aab4697aa1b1491f3ec4a0205ff862"
python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
