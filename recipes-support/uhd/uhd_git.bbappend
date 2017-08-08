PV = "3.11.0"


SRC_URI = "git://git@github.com/EttusResearch/uhddev;branch=mfischer/NOMERGE-bist-liberio;protocol=ssh \
          "

SRCREV = "2cb33b112d40d5bf887aaef2001e45190a81b974"

DEPENDS += " liberio"

EXTRA_OECMAKE_append = " -DENABLE_LIBERIO=ON -DENABLE_RFNOC=ON"
