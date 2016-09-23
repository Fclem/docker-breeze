#!/bin/bash
source run.conf

docker run \
	--name $mysql_cont_name \
	-e MYSQL_ROOT_PASSWORD=`cat .mysql_root_secret` \
	-v /home/clem/dockerb/breeze.sql:/docker-entrypoint-initdb.d/breeze.sql \
	--restart=on-failure \
	-d $mysql_image # fimm/breeze-sql
