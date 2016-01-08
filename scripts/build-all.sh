#!/bin/bash

if ! bitbake parted-native mtools-native dosfstools-native; then
	echo Failed to build toolds needed to run wic.
	exit 1
fi

for MACHINE in ettus-e3xx-sg1 ettus-e3xx-sg3; do

export MACHINE
echo $MACHINE

if ! bitbake gnuradio-dev-image; then
	echo dev image build failed
	exit 1
fi

rm -rf images/$MACHINE/build
if ! wic create ../meta-sdr/contrib/wks/sdimage-8G.wks  -e gnuradio-dev-image -o images/$MACHINE; then 
	echo dev image sd card build failed
	exit 1
fi

export IMAGE_NAME=`ls images/$MACHINE/build/sdimage*mmcblk.direct`
xz -T 4 $IMAGE_NAME
mv $IMAGE_NAME.xz images/$MACHINE/sdimage-gnuradio-dev.direct.xz
md5sum images/$MACHINE/sdimage-gnuradio-dev.direct.xz > images/$MACHINE/sdimage-gnuradio-dev.direct.xz.md5

if ! bitbake gnuradio-demo-image; then
	echo demo image build failed
	exit 1
fi

rm -rf images/$MACHINE/build
if ! wic create ../meta-sdr/contrib/wks/sdimage-8G.wks  -e gnuradio-demo-image -o images/$MACHINE; then
	echo demo image sd card build failed
	exit 1
fi

export IMAGE_NAME=`ls images/$MACHINE/build/sdimage*mmcblk.direct`
xz -T 4 $IMAGE_NAME
mv $IMAGE_NAME.xz images/$MACHINE/sdimage-gnuradio-demo.direct.xz
md5sum images/$MACHINE/sdimage-gnuradio-demo.direct.xz > images/$MACHINE/sdimage-gnuradio-demo.direct.xz.md5

done

bitbake -c populate_sdk gnuradio-dev-image


