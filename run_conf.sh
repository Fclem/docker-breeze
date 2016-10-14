source docker_breeze_img/build.conf
END_C="\e[0m"
RED="\e[91m"
L_CYAN="\e[96m"
L_YELL="\e[93m"
GREEN="\e[32m"

local_root_path=`pwd`
ssh_folder=$local_root_path/.ssh/
code_folder=$local_root_path/code # the root folder of your code (i.e. the one that has requirement.txt)
project_folder=$local_root_path/breeze_data # the breeze project folder (i.e. the one that contains the db/ folder, and the code/ for R code)
docker_root_folder=/root/code
docker_project_folder=/projects/breeze

ssh_cont_name=breeze-ssh # empty file with this name will be created for bash auto completion while using docker start/attach etc.
breeze_cont_name=breeze-one # empty file with this name will be created for bash auto completion while using docker start/attach etc.
mysql_cont_name=breeze-sql # empty file with this name will be created for bash auto completion while using docker start/attach etc.
nginx_cont_name=breeze-nginx # empty file with this name will be created for bash auto completion while using docker start/attach etc.

ssh_image=kingsquare/tunnel:forward
ssh_user=breeze
ssh_server=breeze.northeurope.cloudapp.azure.com
ssh_local_port=3945
ssh_forwarded_ip=127.0.0.1
ssh_remote_port=4243

mysql_image=fimm/mysql
mysql_secret_file=.mysql_root_secret

if [ ! -f $mysql_secret_file ]; then
   	touch $mysql_secret_file
	chmod go-rwx $mysql_secret_file
	echo "Created mysql password file '$mysql_secret_file'."
	echo -e $RED"YOU MUST STORE A VALID PASSWORD FOR MYSQL ROOT USER IN THIS FILE"$END_C
	echo 'THIS_IS_NOT_A_VALID_PASSWORD' > $mysql_secret_file
fi
mysql_secret=`cat $mysql_secret_file`
breeze_image=$repo_name/$img_name
full_img_name=$repo_name/$img_name # change image name here

# TODO FIXME use docker-compose or else

# file system mountig param for django/breeze : code folder, project folder, and setting the working folder # , and ssh config
fs_param="-v $code_folder:$docker_root_folder \
	-v $project_folder/:$docker_project_folder \
	-w $docker_root_folder"

# linking param for django/breeze : the db container, the ssh port fw container
link_param="--link $mysql_cont_name:mysql \
	--link $mysql_cont_name:$mysql_cont_name \
	--link $ssh_cont_name:$ssh_cont_name"
