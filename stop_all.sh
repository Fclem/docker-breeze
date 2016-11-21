#!/bin/bash
source run_conf.sh

echo -e $SHDOL"docker stop $nginx_cont_name $breeze_cont_name $mysql_cont_name $ssh_cont_name"
docker stop $nginx_cont_name $breeze_cont_name $mysql_cont_name $ssh_cont_name && \
echo -e $GREEN"SUCCESS"$END_C && exit 0
echo -e $RED"FAILURE"$END_C
exit 1

