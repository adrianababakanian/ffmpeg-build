#!/bin/sh

mkdir ffmpeg
cd ffmpeg
git init
git remote add origin https://git.ffmpeg.org/ffmpeg.git
git fetch --depth=1 origin "$1"
git checkout "$1"
