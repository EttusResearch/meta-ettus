PV = "3.11.0"


SRC_URI = "git://git@github.com/EttusResearch/uhddev;branch=n3xx-master;protocol=ssh \
          "

SRCREV = "a7f121752df822bb4c4d8de73af2cb13482765d5"

EXTRA_OECMAKE_append = " -DENABLE_LIBERIO=ON -DENABLE_RFNOC=ON -DENABLE_MPMD=ON"

PACKAGECONFIG[liberio] = "-DENABLE_LIBERIO=ON,-DENABLE_LIBERIO=OFF,liberio (>= 0.3),liberio (>= 0.3)"
PACKAGECONFIG[mpmd] = "-DENABLE_MPMD=ON -DENABLE_GPSD=ON,-DENABLE_MPMD=OFF,,gpsd"
PACKAGECONFIG += "liberio mpmd"
