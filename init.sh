#!/bin/bash
source run_conf.sh
git_repo=https://github.com/Fclem/isbio2.git

# TODO improve & finnish. Make a python shell script instead ?

# create empty files for easier bash completition when using docker start/attach etc.
touch $breeze_cont_name
chmod ugo-rwx $breeze_cont_name
touch $mysql_cont_name
chmod ugo-rwx $mysql_cont_name
touch $nginx_cont_name
chmod ugo-rwx $nginx_cont_name
touch $ssh_cont_name
chmod ugo-rwx $ssh_cont_name


# creates project folder if non existant

if [ ! -d "$project_folder" ] ; then
	db_folder=$project_folder/db
	mkdir $project_folder
    	echo "created : "$project_folder
	mkdir $project_folder/code
	mkdir $db_folder $db_folder/configs $db_folder/datasets $db_folder/jobs $db_folder/mould $db_folder/pipelines \
	$db_folder/reports $db_folder/scripts $db_folder/shinyReports $db_folder/shinyTags $db_folder/swap $db_folder/upload_temp
	mkdir $db_folder/configs/engine $db_folder/configs/exec $db_folder/configs/target
else
	echo "Already exists : "$project_folder
fi

# creates code folder if non existant
if [ ! -d "$code_folder" ] ; then
	mkdir $code_folder
   	echo "created : "$code_folder
else
	echo "Already exists : "$project_folder
fi

# if code folder is empty, offer to clone isbio repo
if [ "$(ls -A $code_folder)" ]; then
	echo -e $L_YELL"$code_folder is not empty, if you whish to clone isbio into it, clear it first"$END_C
else
	do_git_clone=y                      # In batch mode => Default is Yes
	echo -n -e $GREEN"\nWould you like to clone ${git_repo} repository in ${code_folder} folder ? "$END_C
	[[ -t 0 ]] &&                  # If tty => prompt the question
	read -n 1 -p \
	$'(Y/n) ' do_git_clone
	if [[ $do_git_clone =~ ^(y|Y|)$ ]]  # Do if 'y', 'Y' or empty
	then
	    # cd $code_folder
		echo  "git clone $git_repo $code_folder"
		git clone $git_repo $code_folder
	else
		echo
	fi
	ln $mysql_secret_file $code_folder/configs/$mysql_secret_file
fi

chmod ugo+r breeze.sql

echo -e $SHDOL"init_ssh-agent.fish"
./init_ssh-agent.fish

docker pull $ssh_image
docker pull $mysql_image # this is an un-edited copy of default docker mysql image
docker pull $breeze_image && echo -e $L_CYAN"Breeze docker image have been downloaded from dockerhub.
"$L_YELL"You can also customize it and build it from docker_breeze_img/"$END_C
echo -e "\e[1;32mTo start breeze, lunch ./run.sh"$END_C
echo -e $GREEN"DONE"$END_C
