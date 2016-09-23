#!/bin/bash
source run.conf
docker rm -f /$breeze_cont_name

docker run \
	-ti \
	--name $breeze_cont_name \
	--link $mysql_cont_name:mysql \
	$fs_param \
	-p 8000:8000 \
	--restart=on-failure \
	$full_img_name \
	/root/code/isbio/manage.py runserver 0.0.0.0:8000
 	
