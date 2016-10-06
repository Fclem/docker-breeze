#!/bin/bash
source run.conf

docker run \
	-ti \
	--rm \
	--name $breeze_cont_name-shell \
	--link $mysql_cont_name:mysql \
	--link $mysql_cont_name:$mysql_cont_name \
	$fs_param \
	-p 8001:8000 \
	$full_img_name \
	/usr/bin/fish

