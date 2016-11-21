#!/bin/bash
source run_conf.sh

launch_cmd="--rm -p 3838:3838 \
	--name $shiny_cont_name \
    $shiny_param \
    $shiny_image"

echo -e $SHDOL"docker run "$launch_cmd

docker run $launch_cmd && exit 0
exit 1
