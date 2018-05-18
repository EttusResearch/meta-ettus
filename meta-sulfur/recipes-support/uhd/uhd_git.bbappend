# current maint doesn't build if OCTOCLOCK is built in ...
EXTRA_OECMAKE_append_ni-sulfur = " -DENABLE_OCTOCLOCK=OFF"

# build maint for now, since FPGA images are tailored to that
PV_ni-sulfur = "3.11.0.1"
SRC_URI_ni-sulfur = "git://github.com/EttusResearch/uhd.git;branch=maint \
           "
SRCREV_ni-sulfur = "a1b5c4ae00335d24d609a075318839d4e9ae5bdd"


PACKAGECONFIG_ni-sulfur = "mpmd liberio"
