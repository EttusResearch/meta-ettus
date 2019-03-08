SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.14"
SRCREV = "f6cacec87e8041d5df019669efe5a88ff02bda4d"
python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
