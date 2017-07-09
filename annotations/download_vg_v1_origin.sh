#!/bin/bash

SCRIPT_DIR=`dirname "$0"`
cd "$SCRIPT_DIR"

# Download the JSON files (region_description.json is not splitted)
wget http://www.ytzhang.net/files/dbnet/data/vg_v1_json.tar.gz
tar -xzf vg_v1_json.tar.gz -C ./vg_v1
rm ./vg_v1_json.tar.gz

# split the annotation file into train, val, test
(cd ./vg_v1; python split_rd.py)

# convert json to mat
(cd ./vg_v1; matlab -nodisplay -r "json2mat; exit")

