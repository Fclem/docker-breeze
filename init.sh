#!/bin/bash
source run.conf
git_repo=https://github.com/Fclem/isbio2.git

# create empty files for easier bash completition when using docker start/attach etc.
touch $breeze_cont_name
chmod ugo-rwx $breeze_cont_name
touch $mysql_cont_name
chmod ugo-rwx $mysql_cont_name


# creates project folder if non existant

if [ ! -d "$project_folder" ] ; then
	db_folder=$project_folder/db
	mkdir $project_folder
    	echo $project_folder", created."
	mkdir $project_folder/code
	mkdir $db_folder $db_folder/configs $db_folder/datasets $db_folder/jobs $db_folder/mould $db_folder/pipelines \
	$db_folder/reports $db_folder/scripts $db_folder/shinyReports $db_folder/shinyTags $db_folder/swap $db_folder/upload_temp
	mkdir $db_folder $db_folder/configs/engine $db_folder $db_folder/configs/exec $db_folder $db_folder/configs/target
else
	echo $project_folder" exists already."
fi

# creates code folder if non existant
if [ ! -d "$code_folder" ] ; then
	mkdir $code_folder
   	echo $code_folder", created."
else
	echo $project_folder" exists already."
fi

# if code folder is empty, offer to clone isbio repo
if [ "$(ls -A $code_folder)" ]; then
	echo "$code_folder is not empty, if you whish to clone isbio into it, clear it first"
else
	do_git_clone=y                      # In batch mode => Default is Yes
	echo -n -e "\e[1;32m\nWould you like to clone ${git_repo} repository in ${code_folder} folder ?\e[0m "
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
fi

docker pull fimm/mysql # this is an un-edited copy of default docker mysql image
docker pull fimm/breeze && echo 'Breeze docker image have been downloaded from dockerhub.
You can also customize it and build it from docker_breeze_img/'

echo "DONE"
echo -e "\e[1;32mTto start breeze, lunch ./my_sql.sh and then ./run.sh\e[0m"
