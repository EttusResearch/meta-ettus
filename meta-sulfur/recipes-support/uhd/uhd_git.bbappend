EXTRA_OECMAKE_append_ni-sulfur = " -DENABLE_OCTOCLOCK=OFF"

RDEPENDS_${PN}_append_ni-sulfur = " uhd-fpga-images-sulfur \
                                    uhd-fpga-images-phosphorus \
                                  "

PACKAGECONFIG_ni-sulfur = "mpmd liberio"
