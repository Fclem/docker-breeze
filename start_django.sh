#!/bin/bash
local_root_path=$(readlink -f $(dirname "$0"))
source $local_root_path/run_conf.sh

echo -e $L_CYAN"Running Django / Breeze container $breeze_cont_name"$END_C

echo "Removing any previously running $breeze_cont_name"
docker rm -f /$breeze_cont_name

all_params="-d -ti --name $breeze_cont_name \
	$link_param \
	$fs_param \
	$full_img_name \
	$docker_root_folder/isbio/manage.py runserver 0.0.0.0:8000"

echo -e $SHDOL"docker run $all_params"

docker run $all_params && echo -e $GREEN"SUCCESS"$END_C && exit 0
echo -e $RED"FAILURE"$END_C
exit 1
# 	-p 8000:8000 \
# 	--restart=on-failure \ 	
