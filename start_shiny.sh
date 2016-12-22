#!/bin/bash
local_root_path=$(readlink -f $(dirname "$0"))
source $local_root_path/run_conf.sh

echo -e $L_CYAN"Running Shiny Server $shiny_cont_name"$END_C

echo "Removing any previously running $shiny_cont_name"
docker rm -f /$shiny_cont_name

all_params="-d --name $shiny_cont_name \
    $shiny_param \
    $shiny_image" # -p 3838:3838



echo -e $SHDOL"docker run $all_params"

docker run $all_params && echo -e $GREEN"SUCCESS"$END_C && exit 0
echo -e $RED"FAILURE"$END_C
exit 1

