#!/bin/bash

source run.conf

docker run --name breeze-nginx \
	-v $local_root_path/nginx/:/root:ro \
	-v $local_root_path/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
	-v $code_folder/static_source/:/www/data/static:ro \
	-d -p 443:443 \
	-p 80:80 \
	nginx

#	--restart=on-failure \
