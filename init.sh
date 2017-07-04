#!/bin/bash
local_root_path=$(readlink -f $(dirname "$0"))
source $local_root_path/init_ssh.sh
source $local_root_path/run_conf.sh
# git_repo=https://github.com/Fclem/isbio2.git

function print_and_do(){
	echo -e $SHDOL$1
	eval $1
}

print_and_do "sudo apt-get update && sudo apt-get upgrade -y"
print_and_do "sudo apt-get install apt-transport-https ca-certificates"

print_and_do "sudo apt-key adv \
               --keyserver hkp://ha.pool.sks-keyservers.net:80 \
               --recv-keys 58118E89F3A912897C070ADBF76221572C52609D"

print_and_do "echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' | sudo tee /etc/apt/sources.list.d/docker.list"
print_and_do "sudo apt-get update"

inst_list=`cat VM_pkg_list`
# echo -e $SHDOL"sudo apt-get install -y $inst_list"
print_and_do "sudo apt-get install -y $inst_list"
print_and_do "sudo gpasswd -a ${USER} docker"
print_and_do "sudo service docker start"


if [ ! -f $mysql_secret_file ]; then
   	touch $mysql_secret_file && \
	chmod go-rwx $mysql_secret_file && \
	echo -e $L_CYAN"Created mysql password file '$mysql_secret_file'."$END_C
	# echo -e $RED"YOU MUST STORE A VALID PASSWORD FOR MYSQL ROOT USER IN THIS FILE"$END_C
	rnd_pass=`pwqgen random=85`
	echo $rnd_pass > $mysql_secret_file
	rnd_pass=''
	mysql_secret=`cat $mysql_secret_file`
fi

# TODO improve & finnish. Make a python shell script instead ?

echo -e $L_CYAN"Creating file and folder structure ..."$END_C

# create empty files for easier bash completition when using docker start/attach etc.
touch $breeze_cont_name
chmod ugo-rwx $breeze_cont_name
touch $mysql_cont_name
chmod ugo-rwx $mysql_cont_name
touch $nginx_cont_name
chmod ugo-rwx $nginx_cont_name
touch $breezedb_cont_name
chmod ugo-rwx $breezedb_cont_name
touch $shiny_cont_name
chmod ugo-rwx $shiny_cont_name


# creates project folder if non existant

if [ ! -d "$project_folder" ] ; then
	db_folder=$project_folder/db
	mkdir $project_folder && \
	echo -e $L_CYAN"created : "$project_folder$END_C
	mkdir $project_folder/code
	mkdir $db_folder $db_folder/configs $db_folder/datasets $db_folder/jobs $db_folder/mould $db_folder/pipelines \
	$db_folder/reports $db_folder/scripts $db_folder/shinyReports $db_folder/shinyTags $db_folder/swap $db_folder/upload_temp
	mkdir $db_folder/configs/engine $db_folder/configs/exec $db_folder/configs/target
else
	echo -e $L_YELL"Already exists : "$project_folder$END_C
fi

# creates code folder if non existant
if [ ! -d "$actual_code_folder" ] ; then
	mkdir $actual_code_folder && \
   	echo -e $L_CYAN"created : "$actual_code_folder$END_C
else
	echo -e $L_YELL"Already exists : "$actual_code_folder$END_C
fi

# creates shiny folder if non existant
if [ ! -d "$shiny_folder" ] ; then
	mkdir $shiny_folder_list && \
   	echo -e $L_CYAN"created : "$shiny_folder_list$END_C
else
	echo -e $L_YELL"Already exists : "$shiny_folder$END_C
fi

print_and_do "ln -s $rel_shiny_folder $shiny_ln"
# ln -s $shiny_folder $shiny_ln

# if code folder is empty, offer to clone isbio repo
if [ "$(ls -A $actual_code_folder 2>/dev/null)" ]; then
	echo -e $L_YELL"$actual_code_folder is not empty, if you which to clone isbio into it, clear it first"$END_C
else
	do_git_clone=y                      # In batch mode => Default is Yes
	echo -n -e $GREEN"\nWould you like to clone ${git_repo} repository in ${actual_code_folder} folder ? "$END_C
	[[ -t 0 ]] &&                  # If tty => prompt the question
	read -n 1 -p \
	$'(Y/n) ' do_git_clone
	echo
	if [[ $do_git_clone =~ ^(y|Y|)$ ]]  # Do if 'y', 'Y' or empty
	then
	    # cd $code_folder
		# echo -e $SHDOL"git clone $git_repo $actual_code_folder"
		print_and_do "git clone $git_repo $actual_code_folder"
	fi

	# create a softlink to the code repo tld
	if [ ! -d "$actual_code_folder" ] ; then
		# echo -e $SHDOL"ln -s $actual_code_folder/ $code_ln"
		print_and_do "ln -s $actual_code_folder $code_ln"
	fi
	# create a softlink to the static source folder
	print_and_do "ln -s $rel_static_source_path $static_source_name"

	# create the secrets folder
	# echo -e $SHDOL"mkdir $breeze_secrets_folder 2>/dev/null"
	print_and_do "mkdir $breeze_secrets_folder 2>/dev/null"

	# echo -e $SHDOL"ln $mysql_secret_file $breeze_secrets_folder/$mysql_secret_file"
	print_and_do "ln $mysql_secret_file $breeze_secrets_folder/$mysql_secret_file"
fi
chmod ugo+r breeze.sql

# save the run mode in .run_mode into the code folder
choose_line="Choose a run-mode (dev | pharma | pharma_dev | prod)? "
echo -n "$choose_line"
run_mode=''
read run_mode
while [ "$run_mode" != 'dev' ] && [ "$run_mode" != 'pharma' ] && [ "$run_mode" != 'pharma_dev' ] && [ "$run_mode" != 'prod' ]
do
	echo "Invalid run-mode '$run_mode'"
	echo -n "$choose_line"
	read run_mode
done
# echo -e $SHDOL"'"$run_mode"'>$actual_code_folder/.run_mode"
print_and_do "echo '$run_mode'>$actual_code_folder/.run_mode"

# GPG
echo -e $L_CYAN"Getting GPG public keys ..."$END_C

# echo -e $SHDOL"gpg --keyserver pgp.mit.edu --recv B4A7FF8614ED9842"
print_and_do "gpg --keyserver pgp.mit.edu --recv B4A7FF8614ED9842"
# echo -e $SHDOL"gpg --keyserver pgp.mit.edu --recv DFDAF03DA18C9EE8"
print_and_do "gpg --keyserver pgp.mit.edu --recv DFDAF03DA18C9EE8"

# SQL conf
echo -n -e $GREEN"Enter the FQDN of this host : "$END_C
read site_domain
echo
echo -n -e $GREEN"Enter the name of this site : "$END_C
read site_name
echo
sql_line="INSERT INTO \`django_site\` SET \`domain\`='$site_domain', \`name\`='$site_name';"
print_and_do "echo '$sql_line' >> ./breeze.sql"

# static content
echo -e $L_CYAN"Getting static content ..."$END_C
print_and_do "git clone https://github.com/Fclem/breeze-static.git $static_source_path"

# DOCKER
echo -e $L_CYAN"Getting docker images ..."$END_C

# echo -e $SHDOL"docker pull $shiny_image"
print_and_do "docker pull $shiny_image" # this is an un-edited copy of default docker shiny image
# echo -e $SHDOL"docker pull $mysql_image"
print_and_do "docker pull $mysql_image" # this is an un-edited copy of default docker mysql image
# echo -e $SHDOL"docker pull $breeze_image"
print_and_do "docker pull nginx" # this is an un-edited copy of default docker mysql image
# echo -e $SHDOL"docker pull nginx"
docker pull $breeze_image && echo -e $L_CYAN"Breeze docker image have been downloaded from dockerhub.
"$L_YELL"You can also customize it and build it from docker_breeze_img/"$END_C
echo -e $BOLD"N.B. before starting Breeze :"$END_C
# echo -e " _ Copy static files to $BOLD$static_source_path$END_C (TODO automatize)"
echo -e " _ Copy req. secrets to $BOLD$breeze_secrets_folder$END_C or use ./init_secret.sh (TODO automatize)"
echo -e " _ Create the nginx configuration file at $BOLD$nginx_conf_file$END_C (TODO automatize)"
echo -e " _ Add the SSL certificates to $BOLD$nginx_folder$END_C"
echo -e " _ if using Breeze-DB you need to copy appropriated files to $BOLD$breezedb_folder$END_C, and run the breeze-db" \
" container before running Breeze"
echo -e $BOLD_GREEN"To start breeze, run './start_all.sh'"$END_C
echo -e $GREEN"DONE"$END_C
