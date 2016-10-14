#!/bin/bash
source run.conf

docker run \
	-ti \
	--rm \
	--name $breeze_cont_name-shell \
	$link_param \
	$fs_param \
	$full_img_name \
	/usr/bin/fish

# 	-p 8001:8000 \

