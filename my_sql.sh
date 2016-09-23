#!/bin/bash
source run.conf

run_args="--name $mysql_cont_name \
	-e MYSQL_ROOT_PASSWORD=$mysql_secret \
	-v $local_root_path/breeze.sql:/docker-entrypoint-initdb.d/breeze.sql \
	--restart=on-failure \
	-d $mysql_image"

echo $run_args

docker run $run_args
#	--name $mysql_cont_name \
#	-e MYSQL_ROOT_PASSWORD=$mysql_secret \
#	-v $local_root_path/breeze.sql:/docker-entrypoint-initdb.d/breeze.sql \
#	--restart=on-failure \
#	-d $mysql_image
