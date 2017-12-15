PV = "3.11.0"


SRC_URI = "git://git@github.com/EttusResearch/uhddev;branch=n3xx-master;protocol=ssh \
          "

SRCREV = "7e8044b089fa81f4f181de8275df0b1a7e5ee9eb"

EXTRA_OECMAKE_append = " -DENABLE_LIBERIO=ON -DENABLE_RFNOC=ON -DENABLE_MPMD=ON"

PACKAGECONFIG[liberio] = "-DENABLE_LIBERIO=ON,-DENABLE_LIBERIO=OFF,liberio (>= 0.3),liberio (>= 0.3)"
PACKAGECONFIG[mpmd] = "-DENABLE_MPMD=ON -DENABLE_GPSD=ON,-DENABLE_MPMD=OFF,,gpsd"
PACKAGECONFIG += "liberio mpmd"
