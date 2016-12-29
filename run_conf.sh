local_root_path=$(readlink -f $(dirname "$0"))
source $local_root_path/docker_breeze_img/build.conf
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

# local_root_path=`pwd`

cd $local_root_path
ssh_folder=$local_root_path/.ssh/
code_folder=$local_root_path/code # the root folder of your code (i.e. the one that has requirement.txt)
actual_code_folder=`readlink -f ../$git_repo_name/`
project_folder=$local_root_path/breeze_data # the breeze project folder (i.e. the one that contains the db/ folder, and the code/ for R code)
home_folder=/home/breeze
static_source_name='static_source'
static_source_path=`readlink -f ../$static_source_name/`
docker_root_folder=$home_folder/code
docker_project_folder=/projects/breeze
breeze_secrets_folder=$code_folder/configs
shiny_folder=`readlink -f ../shiny`
shiny_log_folder=$shiny_folder/.log
shiny_serv_folder=$shiny_folder/shiny
shiny_app_folder=$shiny_serv_folder/breeze
shiny_pub_folder=$shiny_serv_folder/pub
shiny_ln=$local_root_path/shiny
code_ln="code"
breezedb_folder=`readlink -f ../breeze-db/`

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

shiny_image=fimm/shiny # this is an un-edited copy of default docker shiny image
mysql_image=fimm/mysql # this is an un-edited copy of default docker mysql image
mysql_secret_file=.mysql_root_secret
mysql_secret=`cat $mysql_secret_file`
breeze_image=$repo_name/$img_name
full_img_name=$repo_name/$img_name:ph1 # change image name here

# TODO FIXME use docker-compose or else

# Optional ssh bridge link and fs mount options
ssh_sup_fs="-v $ssh_folder:/root/.ssh/"
ssh_sup_link=""
if [ "1" -eq $ssh_enabled ]; then
	# ssh_sup_fs="-v $ssh_folder:/root/.ssh/"
	ssh_sup_link="--link $ssh_cont_name:$ssh_cont_name"
else
	ssh_cont_name=''
	ssh_image=''
fi

# Optional Breeze-DB link
docker inspect $breezedb_cont_name >/dev/null 2>/dev/null
has_breezedb=$?
breezedb_sup_link=''
if [ "0" -eq $has_breezedb ]; then
	breezedb_sup_link="--link $breezedb_cont_name:$breezedb_cont_name"
fi

# list of containers names, and images names
disposable_containers_list="$nginx_cont_name $breeze_cont_name $ssh_cont_name $ssh_cont_name"
containers_list="$disposable_containers_list $mysql_cont_name"
image_list="$shiny_image $mysql_image $breeze_image $ssh_image"

#pharma="--add-host=\"qmaster.giu.fi:10.69.1.1\" \
#-v /var/lib/gridengine:/var/lib/gridengine"
pharma="-v /var/lib/gridengine:/var/lib/gridengine \
-v /usr/lib/gridengine:/usr/lib/gridengine \
-v /usr/lib/gridengine-drmaa:/usr/lib/gridengine-drmaa"
# 	-v /opt/gridengine/lib/lx26-amd64
#	-v /var/lib/gridengine:/var/lib/gridengine

# file system mountig param for django/breeze : code folder, project folder, and setting the working folder # , and ssh config
fs_param="-v $code_folder:$docker_root_folder \
	-v $local_root_path/hello.sh:$home_folder/hello.sh \
	-v $static_source_path:$home_folder/$static_source_name:ro \
	-v $project_folder/:$docker_project_folder \
	-v $project_folder/:$docker_project_folder-ph2 \
	$ssh_sup_fs \
	$pharma \
	-w $docker_root_folder"

# linking param for django/breeze : the db container, the ssh port fw container
link_param="--link $mysql_cont_name:mysql \
	--link $mysql_cont_name:$mysql_cont_name \
	--link $shiny_cont_name:$shiny_cont_name \
	-h breeze-pharma \
	$breezedb_sup_link	$ssh_sup_link"

# file system mounts for shiny apps and logs
shiny_param="-v $shiny_serv_folder/:/srv/shiny-server/ \
-v $shiny_log_folder/:/var/log/"

# --link $breezedb_cont_name:breeze.northeurope.cloudapp.azure.com
