PV = "3.11.0"


SRC_URI = "git://git@github.com/EttusResearch/uhddev;branch=n3xx-master;protocol=ssh \
          "

SRCREV = "7a588a564529a29389371b9990477c4dab8a1771"

EXTRA_OECMAKE_append = " -DENABLE_LIBERIO=ON -DENABLE_RFNOC=ON -DENABLE_MPMD=ON"

PACKAGECONFIG[liberio] = "-DENABLE_LIBERIO=ON,-DENABLE_LIBERIO=OFF,liberio (>= 0.3),liberio (>= 0.3)"
PACKAGECONFIG[mpmd] = "-DENABLE_MPMD=ON -DENABLE_GPSD=ON,-DENABLE_MPMD=OFF,,gpsd"
PACKAGECONFIG += "liberio mpmd"
