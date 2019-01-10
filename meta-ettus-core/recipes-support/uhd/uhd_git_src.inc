SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.13"
SRCREV = "78745bda5de0beed0411c4b1baf3783d84090024"
python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
