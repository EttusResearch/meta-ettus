SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.15.LTS"
SRCREV = "dbaf4132f647218110d4e350f1a4a943e0e9258e"

python () {
    d.setVar('UHD_GIT_HASH', "g" + d.getVar('SRCREV', True)[0:8])
}
EXTRA_OECMAKE += "-DUHD_GIT_HASH=${UHD_GIT_HASH}"
