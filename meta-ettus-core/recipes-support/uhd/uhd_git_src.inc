SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.15.LTS"
SRCREV = "aea0e2de34803d5ea8f25d7cf2fb08f4ab9d43f0"

python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
