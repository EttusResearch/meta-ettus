#!/bin/bash

if ! bitbake parted-native mtools-native dosfstools-native; then
	echo Failed to build toolds needed to run wic.
	exit 1
fi

machines="ettus-e3xx-sg1 ettus-e3xx-sg3"
flavours="gnuradio-dev gnuradio-demo"
for MACHINE in $machines; do

	export MACHINE
	echo $MACHINE

	for FLAVOUR in $flavours;do
		if ! bitbake $FLAVOUR-image; then
			echo $FLAVOUR image build failed
			exit 1
		fi

		rm -rf images/$MACHINE/build
		if ! wic create ../meta-sdr/contrib/wks/sdimage-8G.wks  -e $FLAVOUR-image -o images/$MACHINE; then 
			echo $FLAVOUR image sd card build failed
			exit 1
		fi

		export IMAGE_NAME=`ls images/$MACHINE/build/sdimage*mmcblk.direct`
		xz -T 4 $IMAGE_NAME
		mv $IMAGE_NAME.xz images/$MACHINE/sdimage-$FLAVOUR.direct.xz
		md5sum images/$MACHINE/sdimage-$FLAVOUR.direct.xz > images/$MACHINE/sdimage-$FLAVOUR.direct.xz.md5
	done


done

bitbake -c populate_sdk $FLAVOUR-image


