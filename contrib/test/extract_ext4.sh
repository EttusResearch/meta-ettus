#!/bin/bash

# === example output ===
#
#label: dos
#label-id: 0xe4b3a525
#device: oe-build/build/tmp-glibc/deploy/images/ni-sulfur-rev5/developer-image-ni-sulfur-rev5.sdimg
#unit: sectors
#
#oe-build/build/tmp-glibc/deploy/images/ni-sulfur-rev5/developer-image-ni-sulfur-rev5.sdimg1 : start=       49152, size=       32768, type=c, bootable
#oe-build/build/tmp-glibc/deploy/images/ni-sulfur-rev5/developer-image-ni-sulfur-rev5.sdimg2 : start=       81920, size=    15347712, type=83
#oe-build/build/tmp-glibc/deploy/images/ni-sulfur-rev5/developer-image-ni-sulfur-rev5.sdimg3 : start=    15433728, size=    15347712, type=83
#oe-build/build/tmp-glibc/deploy/images/ni-sulfur-rev5/developer-image-ni-sulfur-rev5.sdimg4 : start=    30785536, size=      262144, type=83

if [ -z "$1" ]
then
  echo "usage: $0 <image>"
  exit 1
else
  IMAGE=$1
fi

if [[ $(echo $IMAGE | tail -c 6) == ".ext4" ]]; then
  echo "$IMAGE is already a .ext4 file"
  exit 0
elif [[ $(echo $IMAGE | tail -c 4) == ".gz" ]]; then
  MBR=$(echo $IMAGE | sed "s|^\(.*\)\.\(.*\)\.gz$|\1.mbr|")
  EXT4=$(echo $IMAGE | sed "s|^\(.*\)\.\(.*\)\.gz$|\1.ext4|")
  UNZIP="gunzip -k --stdout"
  $UNZIP --stdout $IMAGE | head -c 512 > $MBR
elif [[ $(echo $IMAGE | tail -c 5) == ".bz2" ]]; then
  MBR=$(echo $IMAGE | sed "s|^\(.*\)\.\(.*\)\.bz2$|\1.mbr|")
  EXT4=$(echo $IMAGE | sed "s|^\(.*\)\.\(.*\)\.bz2$|\1.ext4|")
  UNZIP="bzip2 -d --stdout"
  $UNZIP $IMAGE | head -c 512 > $MBR
else
  MBR=$(echo $IMAGE | sed "s|^\(.*\)\.\(.*\)$|\1.mbr|")
  EXT4=$(echo $IMAGE | sed "s|^\(.*\)\.\(.*\)$|\1.ext4|")
  head -c 512 $IMAGE > $MBR
fi

if [ $# -ge 2 ]; then
  EXT4=$2
fi

sfdisk -ld $MBR | while read LINE;
do
  #echo "LINE=$LINE"
  MATCH=$(echo "$LINE" | grep -e "^$MBR")
  if [ ! -z "$MATCH" ]
  then
    #echo "MATCH=$MATCH"
    let i=i+1
    case $i in
      1) NAME=boot;;
      2) NAME=primary;;
      3) NAME=secondary;;
      4) NAME=data;;
      *) NAME="unknown$i";;
    esac
    #let START=512*$(echo "$MATCH" | sed -n "s/.*start\=\s*\([0-9][0-9]*\).*/\1/p")+1
    #let SIZE=512*$(echo "$MATCH" | sed -n "s/.*size\=\s*\([0-9][0-9]*\).*/\1/p")
    let START=$(echo "$MATCH" | sed -n "s/.*start\=\s*\([0-9][0-9]*\).*/\1/p")
    let SIZE=$(echo "$MATCH" | sed -n "s/.*size\=\s*\([0-9][0-9]*\).*/\1/p")
    #sudo mkdir -p /mnt/$NAME
    #sudo mount -o loop,offset=$START,sizelimit=$SIZE $IMAGE /mnt/$NAME
    if [[ $NAME == "primary" ]]; then
      #echo "gunzip -k --stdout $IMAGE | tail -c +$START | head -c $SIZE > $EXT4"
      #gunzip -k --stdout $IMAGE | tail -c +$START | head -c $SIZE > $EXT4
      if [[ -n "$UNZIP" ]]; then
        echo "$UNZIP $IMAGE | dd bs=512 skip=$START count=$SIZE status=progress of=$EXT4"
        $UNZIP $IMAGE | dd bs=512 skip=$START count=$SIZE status=progress of=$EXT4
      else
        echo "dd bs=512 skip=$START count=$SIZE status=progress if=$IMAGE of=$EXT4"
        dd bs=512 skip=$START count=$SIZE status=progress if=$IMAGE of=$EXT4
      fi
    fi
  fi
done
