#!/bin/bash

source run.conf

docker run --name breeze-nginx \
	-v $local_root_path/nginx/:/etc/nginx/:ro \
	--restart=on-failure \
	-d -p 443:443 \
	-p 80:80 \
	nginx
