SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.14"
SRCREV = "c7941e058513fcd6391b4dd9f4a8765c3df9a187"

python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
