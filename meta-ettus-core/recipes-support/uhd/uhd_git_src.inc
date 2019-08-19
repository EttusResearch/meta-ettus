SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.14"
SRCREV = "98c7c98648c5789d4088637bb45aae23c4199bc6"
python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
