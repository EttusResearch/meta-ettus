SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.13"
SRCREV = "bbce3e453e10473d8e3301a70c9896c8a486be60"
python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
