#!/bin/bash

SCRIPT_DIR=`dirname "$0"`
cd "$SCRIPT_DIR"

wget --continue http://www.ytzhang.net/files/dbnet/results/vg_v1_resnet101_sample_test.tar.gz
tar -xzf vg_v1_resnet101_sample_test.tar.gz
rm ./vg_v1_resnet101_sample_test.tar.gz

