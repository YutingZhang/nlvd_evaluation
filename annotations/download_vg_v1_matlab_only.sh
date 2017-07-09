#!/bin/bash

SCRIPT_DIR=`dirname "$0"`
cd "$SCRIPT_DIR"

# Download mat files

wget http://www.ytzhang.net/files/dbnet/data/vg_v1_mat_splitted.tar.gz
tar -xzf vg_v1_mat_splitted.tar.gz -C ./vg_v1/
rm ./vg_v1_mat_splitted.tar.gz

