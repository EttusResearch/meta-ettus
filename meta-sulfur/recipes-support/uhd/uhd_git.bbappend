EXTRA_OECMAKE_append_ni-sulfur = " -DENABLE_OCTOCLOCK=OFF"

RDEPENDS_${PN}_append_ni-sulfur = " uhd-fpga-images-sulfur \
                                    uhd-fpga-images-phosphorus \
                                    uhd-fpga-images-rhodium \
                                  "

PACKAGECONFIG_ni-sulfur = "mpmd liberio"
