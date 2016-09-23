#!/bin/bash

source run.conf

docker run --name breeze-nginx \
	-v nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
	-v nginx/1_vm0326.kaj.pouta.csc.fi_bundle.crt:/root/1_vm0326.kaj.pouta.csc.fi_bundle.crt:ro \
	-v nginx/server.pem:/root/server.pem:ro \
	--restart=on-failure \
	-d -p 443:443 \
	-p 80:80 \
	nginx
