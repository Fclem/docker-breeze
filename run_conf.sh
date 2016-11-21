source docker_breeze_img/build.conf
git_repo_name="isbio2"
git_repo=https://github.com/Fclem/$git_repo_name.git

END_C="\e[0m"
RED="\e[91m"
L_CYAN="\e[96m"
BOLD_GREEN="\e[1;32m"
L_YELL="\e[93m"
GREEN="\e[32m"
BOLD="\e[1m"
SHDOL=$GREEN$BOLD"$"$END_C" "

local_root_path=`pwd`
ssh_folder=$local_root_path/.ssh/
code_folder=$local_root_path/code # the root folder of your code (i.e. the one that has requirement.txt)
actual_code_folder=`readlink -f ../$git_repo_name/`
project_folder=$local_root_path/breeze_data # the breeze project folder (i.e. the one that contains the db/ folder, and the code/ for R code)
docker_root_folder=/root/code
docker_project_folder=/projects/breeze
breeze_secrets_folder=$code_folder/configs
shiny_folder=`readlink -f ../shiny`
shiny_log_folder=$shiny_folder/.log
shiny_serv_folder=$shiny_folder/shiny
shiny_app_folder=$shiny_serv_folder/breeze
shiny_pub_folder=$shiny_serv_folder/pub
shiny_ln=$local_root_path/shiny
code_ln="code"

shiny_folder_list="$shiny_folder $shiny_log_folder $shiny_serv_folder $shiny_app_folder $shiny_pub_folder"

ssh_cont_name=breeze-ssh		# empty file with this name will be created for bash auto completion while using docker start/attach etc.
breeze_cont_name=breeze-one		# empty file with this name will be created for bash auto completion while using docker start/attach etc.
mysql_cont_name=breeze-sql		# empty file with this name will be created for bash auto completion while using docker start/attach etc.
breezedb_cont_name=breeze-db	# empty file with this name will be created for bash auto completion while using docker start/attach etc.
nginx_cont_name=breeze-nginx	# empty file with this name will be created for bash auto completion while using docker start/attach etc.
shiny_cont_name=breeze-shiny	# empty file with this name will be created for bash auto completion while using docker start/attach etc.

ssh_image=kingsquare/tunnel:forward
ssh_user=breeze
# ssh_server=breeze.northeurope.cloudapp.azure.com
# ssh_enabled=0
source ssh_enabled.sh
ssh_server=10.0.1.4
ssh_local_port=3945
ssh_forwarded_ip=127.0.0.1
ssh_remote_port=4243

shiny_image=rocker/shiny # this is an un-edited copy of default docker shiny image
mysql_image=fimm/mysql # this is an un-edited copy of default docker mysql image
mysql_secret_file=.mysql_root_secret
mysql_secret=`cat $mysql_secret_file`
breeze_image=$repo_name/$img_name
full_img_name=$repo_name/$img_name # change image name here

# TODO FIXME use docker-compose or else

ssh_sup_fs=""
ssh_sup_link=""
if [ "1" -eq $ssh_enabled ]; then
	ssh_sup_fs="-v $ssh_folder:/root/.ssh/"
	ssh_sup_link="--link $ssh_cont_name:$ssh_cont_name"
else
	ssh_cont_name=''
	ssh_image=''
fi

disposable_containers_list="$nginx_cont_name $breeze_cont_name $ssh_cont_name $ssh_cont_name"
containers_list="$disposable_containers_list $mysql_cont_name"
image_list="$shiny_image $mysql_image $breeze_image $ssh_image"

# file system mountig param for django/breeze : code folder, project folder, and setting the working folder # , and ssh config
fs_param="-v $code_folder:$docker_root_folder \
	-v $project_folder/:$docker_project_folder \
	$ssh_sup_fs \
	-w $docker_root_folder"

# linking param for django/breeze : the db container, the ssh port fw container
link_param="--link $mysql_cont_name:mysql \
	--link $mysql_cont_name:$mysql_cont_name \
	--link $breezedb_cont_name:$breezedb_cont_name \
	--link $shiny_cont_name:$shiny_cont_name \
	$ssh_sup_link"

shiny_param="-v $shiny_serv_folder/:/srv/shiny-server/ \
    -v $shiny_log_folder/:/var/log/"

# --link $breezedb_cont_name:breeze.northeurope.cloudapp.azure.com
