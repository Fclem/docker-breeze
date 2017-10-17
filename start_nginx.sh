#!/bin/bash
local_root_path=$(readlink -f $(dirname "$0"))
source $local_root_path/run_conf.sh

echo -e $L_CYAN"Running Nginx container $nginx_cont_name"$END_C

echo "Removing any previously running $nginx_cont_name"
docker rm -f /$nginx_cont_name

all_params="-d --name $nginx_cont_name \
	-v $local_root_path/nginx/:/root:ro \
	-v $local_root_path/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
	-v $local_root_path/../static_source/:/www/data/static:ro \
	-v $project_folder/db/reports/_cache/:/www/data/reports/:ro \
	--link $breeze_cont_name:$breeze_cont_name \
	--link $shiny_cont_name:$shiny_cont_name \
	--restart=on-failure \
	-p 443:443 \
	-p 80:80 \
	nginx"

echo -e $SHDOL"docker run $all_params"

docker run $all_params && echo -e $GREEN"SUCCESS"$END_C && exit 0
echo -e $RED"FAILURE"$END_C
exit 1

# 	--link breeze-two:breeze-two \
