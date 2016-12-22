#!/bin/bash
local_root_path=$(readlink -f $(dirname "$0"))
source $local_root_path/run_conf.sh

echo -e $SHDOL"docker stop $containers_list"
docker stop $containers_list && \
echo -e $GREEN"SUCCESS"$END_C && exit 0
echo -e $RED"FAILURE"$END_C
exit 1

