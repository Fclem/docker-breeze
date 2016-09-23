#!/bin/bash
source run.conf
git_repo=https://github.com/Fclem/isbio.git

# create empty files for easier bash completition when using docker start/attach etc.
touch $breeze_cont_name
chmod ugo-rwx $breeze_cont_name
touch $mysql_cont_name
chmod ugo-rwx $mysql_cont_name

# creates project folder if non existant

if [ ! -d "$project_folder" ] ; then
	mkdir $project_folder
    	echo $project_folder", created."
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

echo "DONE"
