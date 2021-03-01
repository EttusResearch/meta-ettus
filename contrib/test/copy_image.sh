#!/bin/bash

if [ $# -lt 3 ]; then
  echo "usage: $0 <origin> <imagesdir> <mountpoint>"
  exit 0
fi

SCRIPTDIR=$(dirname $0)
ORIGIN=$1
IMAGESDIR=$2
MOUNTPOINT=$3

if echo $ORIGIN | grep -o -q -e "^http://" -e "^https://" -e "^ftp://"; then
  wget -S -N --progress=bar:force:noscroll -P $IMAGESDIR $ORIGIN
else
  rsync -v --copy-links --progress $ORIGIN $IMAGESDIR
fi

if [ $? -ne 0 ]; then
  echo "Error: could not download image"
  exit 1
fi

IMAGE=$IMAGESDIR/$(basename $ORIGIN)

if echo $IMAGE | grep -o -q -e ".ext4$"; then
  IMAGE_EXT4=$IMAGE
else
  echo "extracting ext4 image from image: $IMAGE"
  $SCRIPTDIR/extract_ext4.sh $IMAGE
  IMAGE_EXT4=$(echo $IMAGE | sed "s|^\(.*\)\.gz$|\1|" | sed "s|^\(.*\)\.[a-z]*$|\1.ext4|")

  if [ $? -ne 0 ]; then
    echo "Error: could not extract ext4 image"
    exit 1
  fi
fi

if [ ! -r $IMAGE_EXT4 ]; then
  echo "Error: cannot read image $IMAGE_EXT4"
  exit 1
fi
echo "Using ext4 image: $IMAGE_EXT4"

IMAGE_MNT=$(grep -e $MOUNTPOINT /etc/fstab | grep -o -e "^\S*")

if [ -z $IMAGE_MNT ]; then
  echo "Error: could not find image matching mountpoint $MOUNTPOINT in /etc/fstab"
  exit 1
fi

echo "Creating symlink $IMAGE_MNT -> $IMAGE_EXT4"
rm -f $IMAGE_MNT
ln -s $IMAGE_EXT4 $IMAGE_MNT
