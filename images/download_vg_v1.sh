#!/bin/bash

SCRIPT_DIR=`dirname "$0"`
cd "$SCRIPT_DIR"

mkdir -p vg_download
cd vg_download

wget --continue https://cs.stanford.edu/people/rak248/VG_100K_2/images.zip
wget --continue https://cs.stanford.edu/people/rak248/VG_100K_2/images2.zip

cd ..

mkdir -p vg
ln -sf vg vg_v1
cd vg

unzip ../vg_download/images.zip
unzip ../vg_download/images2.zip

cd ..

rm -r vg_download

