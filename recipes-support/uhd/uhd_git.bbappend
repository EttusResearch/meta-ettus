PV = "3.11.0"


SRC_URI = "git://git@github.com/EttusResearch/uhddev;branch=n3xx-master;protocol=ssh \
          "

SRCREV = "7f8c1fcb9ded7cc56f366740a01d826b3949ee6c"

EXTRA_OECMAKE_append = " -DENABLE_LIBERIO=ON -DENABLE_RFNOC=ON"

PACKAGECONFIG[liberio] = "-DENABLE_LIBERIO=ON,-DENABLE_LIBERIO=OFF,,liberio (>= 0.3)"
PACKAGECONFIG += "liberio"
