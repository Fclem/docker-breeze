#!/bin/bash
source run.conf
docker rm -f /$breeze_cont_name

docker run \
	-d -ti \
	--name $breeze_cont_name \
	--link $mysql_cont_name:mysql \
	$fs_param \
	-p 8000:8000 \

	$full_img_name \
	$docker_root_folder/isbio/manage.py runserver 0.0.0.0:8000 && exit 0
exit 1
# 	--restart=on-failure \ 	
