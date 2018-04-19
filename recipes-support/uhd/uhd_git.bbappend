PV = "3.11.0.1"

include uhd-rev.inc

EXTRA_OECMAKE_append = " -DENABLE_LIBERIO=ON -DENABLE_RFNOC=OFF -DENABLE_MPMD=ON -DENABLE_OCTOCLOCK=OFF"

PACKAGECONFIG[liberio] = "-DENABLE_LIBERIO=ON,-DENABLE_LIBERIO=OFF,liberio (>= 0.3),liberio (>= 0.3)"
PACKAGECONFIG[mpmd] = "-DENABLE_MPMD=ON -DENABLE_GPSD=ON,-DENABLE_MPMD=OFF,,gpsd"
PACKAGECONFIG += "liberio mpmd"
