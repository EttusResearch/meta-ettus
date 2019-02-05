SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.14"
SRCREV = "6875d061d8dd3cc59427638d35f76079beb34e70"
python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
