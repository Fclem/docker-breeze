#!/bin/bash
source init_ssh.sh
source run_conf.sh
# git_repo=https://github.com/Fclem/isbio2.git
inst_list=`cat VM_pkg_list`
echo -e $SHDOL"sudo apt-get install -y $inst_list"
sudo apt-get install -y $inst_list
echo -e $SHDOL"sudo apt-get update && sudo apt-get upgrade -y"
sudo apt-get update && sudo apt-get upgrade -y

if [ ! -f $mysql_secret_file ]; then
   	touch $mysql_secret_file && \
	chmod go-rwx $mysql_secret_file && \
	echo -e $L_CYAN"Created mysql password file '$mysql_secret_file'."$END_C
	# echo -e $RED"YOU MUST STORE A VALID PASSWORD FOR MYSQL ROOT USER IN THIS FILE"$END_C
	rnd_pass=`pwqgen random=85`
	echo $rnd_pass > $mysql_secret_file
	rnd_pass=''
fi

# TODO improve & finnish. Make a python shell script instead ?

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

echo -e $SHDOL"ln -s $shiny_folder $shiny_ln"
ln -s $shiny_folder $shiny_ln

# if code folder is empty, offer to clone isbio repo
if [ "$(ls -A $actual_code_folder 2>/dev/null)" ]; then
	echo -e $L_YELL"$actual_code_folder is not empty, if you whish to clone isbio into it, clear it first"$END_C
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
		echo -e $SHDOL"git clone $git_repo $actual_code_folder"
		git clone $git_repo $actual_code_folder
	fi

	# create a softlink to the code repo tld
	if [ ! -d "$actual_code_folder" ] ; then
		echo -e $SHDOL"ln -s $actual_code_folder $code_ln"
		ln -s $actual_code_folder $code_ln
	fi

	# create the screts folder
	echo -e $SHDOL"mkdir $breeze_secrets_folder 2>/dev/null"
	mkdir $breeze_secrets_folder 2>/dev/null

	echo -e $SHDOL"ln $mysql_secret_file $breeze_secrets_folder/$mysql_secret_file"
	ln $mysql_secret_file $breeze_secrets_folder/$mysql_secret_file
fi

chmod ugo+r breeze.sql

echo -e $SHDOL"docker pull $shiny_image"
docker pull $shiny_image # this is an un-edited copy of default docker shiny image
echo -e $SHDOL"docker pull $mysql_image"
docker pull $mysql_image # this is an un-edited copy of default docker mysql image
echo -e $SHDOL"docker pull $breeze_image"
docker pull nginx # this is an un-edited copy of default docker mysql image
echo -e $SHDOL"docker pull nginx"
docker pull $breeze_image && echo -e $L_CYAN"Breeze docker image have been downloaded from dockerhub.
"$L_YELL"You can also customize it and build it from docker_breeze_img/"$END_C
echo -e $BOLD"N.B. before starting Breeze :"$END_C
echo -e " _ Copy static files to $BOLD$code_folder/static_source$END_C"
echo -e " _ Copy req. secrets to $BOLD$breeze_secrets_folder$END_C"
echo -e " _ if using Breeze-DB you need to copy apropriate files to $BOLD$breezedb_folder$END_C"
echo -e $BOLD_GREEN"To start breeze, run './start_all.sh'"$END_C
echo -e $GREEN"DONE"$END_C
