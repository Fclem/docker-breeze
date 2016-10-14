#!/bin/bash

source run_conf.sh

now=`date --rfc-3339=second | sed 's/ /T/'`

echo -e $SHDOL"./stop_all.sh"
./stop_all.sh && \
echo -e $SHDOL"docker rm $nginx_cont_name $breeze_cont_name $ssh_cont_name" && \
docker rm $nginx_cont_name $breeze_cont_name $ssh_cont_name && \
echo -e $SHDOL"docker rename $mysql_cont_name $mysql_cont_name""_$now" && \
docker rename $mysql_cont_name $mysql_cont_name"_"$now && \
echo -e $GREEN"SUCCESS"$END_C && exit 0

echo -e $RED"FAILURE"$END_C
exit 1

