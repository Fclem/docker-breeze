#!/bin/bash
source run_conf.sh

breeze_cont_name='IPythonNote'

echo -e $L_CYAN"Running IPython / Notebook container $breeze_cont_name"$END_C

echo "Removing any previously running $breeze_cont_name"
docker rm -f /$breeze_cont_name

all_params="-d -ti --name $breeze_cont_name \
	$link_param \
	$fs_param \
	-p 127.0.0.1:8888:8888 \
	$full_img_name \
	$docker_root_folder/notebook.sh"

echo -e $SHDOL"docker run $all_params"

docker run $all_params && echo -e $GREEN"SUCCESS"$END_C && exit 0
echo -e $RED"FAILURE"$END_C
exit 1
# 	-p 8000:8000 \
# 	--restart=on-failure \ 	
