#!/bin/bash

SCRIPT_DIR=`dirname "$0"`
cd "$SCRIPT_DIR"

# Download JSON files (region_description.json has been splitted, and it is not included)
wget http://www.ytzhang.net/files/dbnet/data/vg_v1_json_splitted.tar.gz
tar -xzf vg_v1_json_splitted.tar.gz -C ./vg_v1/

# Download MAT files (region_description.json has been splitted, and it is not included)
wget http://www.ytzhang.net/files/dbnet/data/vg_v1_mat_splitted.tar.gz
tar -xzf vg_v1_mat_splitted.tar.gz -C ./vg_v1/

rm ./vg_v1_json_splitted.tar.gz
rm ./vg_v1_mat_splitted.tar.gz

