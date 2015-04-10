export MACHINE=ettus-e300

if ! bitbake gnuradio-demo-image; then
	echo Image build failed, do not create SD card image
	exit 1
fi




if ! wic create ../meta-sdr/contrib/wks/sdimage-8G.wks  -e gnuradio-demo-image -o factory-images/$MACHINE; then
	echo Failed to create SD card image, aborting
	exit 1
fi

xz factory-images/$MACHINE/build/sdimage*direct

bitbake -c populate_sdk gnuradio-demo-image

