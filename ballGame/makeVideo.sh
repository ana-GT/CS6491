#!/bin/bash

VIDEO_FOLDER=('Pictures')
ELEMENTS=${#VIDEO_FOLDER[@]}
FORMAT=avi
FPS=15

echo "**  Generate videos"

for (( i=-0; i<$ELEMENTS;i++)); do
    if [ -e ${VIDEO_FOLDER[${i}]}.${FORMAT} ]; then
	echo "--> Video ${VIDEO_FOLDER[${i}]}.${FORMAT} exists"
	else 
	echo "Creating video ${VIDEO_FOLDER[${i}]}.${FORMAT}"

	cd ${VIDEO_FOLDER[${i}]}
	echo `ffmpeg -qscale 5 -r ${FPS} -i %06d.png ../${VIDEO_FOLDER[${i}]}.${FORMAT}`
	cd ..
	fi
done
