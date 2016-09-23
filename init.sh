#!/bin/bash
source run.conf
git_repo=https://github.com/Fclem/isbio2.git
END_C="\e[0m"
RED="\e[91m"
L_CYAN="\e[96m"
L_YELL="\e[93m"
GREEN="\e[32m"

# create empty files for easier bash completition when using docker start/attach etc.
touch $breeze_cont_name
chmod ugo-rwx $breeze_cont_name
touch $mysql_cont_name
chmod ugo-rwx $mysql_cont_name


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
fi

docker pull fimm/mysql # this is an un-edited copy of default docker mysql image
docker pull fimm/breeze && echo -e $L_CYAN"Breeze docker image have been downloaded from dockerhub.
"$L_YELL"You can also customize it and build it from docker_breeze_img/"$END_C

echo "DONE"
echo -e "\e[1;32mTto start breeze, lunch ./my_sql.sh and then ./run.sh"$END_C
