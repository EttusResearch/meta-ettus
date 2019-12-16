SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.15.LTS"
SRCREV = "4e06022c383a78434b054a349130c218540ea6f4"

python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
