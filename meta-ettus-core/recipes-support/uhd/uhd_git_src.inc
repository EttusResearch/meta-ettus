SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.13"
SRCREV = "4a356623b46adf2117914c565d0322638912bb1a"
python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
