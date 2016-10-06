#!/bin/bash

source run.conf

echo "docker stop $nginx_cont_name $breeze_cont_name $mysql_cont_name"
docker stop $nginx_cont_name $breeze_cont_name $mysql_cont_name && \
exit 0

exit 1

