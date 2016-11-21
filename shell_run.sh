#!/bin/bash
source run_conf.sh

all_params="-ti --rm \
	--name $breeze_cont_name-shell \
	$link_param \
	$fs_param \
	$full_img_name \
	/usr/bin/fish"

echo -e $SHDOL"docker run "$all_params

docker run $all_params && exit 0
exit 1

# 	-p 8001:8000 \

