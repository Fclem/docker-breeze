#!/usr/bin/env bash
local_root_path=$(readlink -f $(dirname "$0"))
source ${local_root_path}/run_conf.sh

if [ -f ~/.ssh/id_rsa.pub ]; then
	if [ -d "${R_code_folder}" ] ; then
		echo -e "${L_YELL}The R source code folder ${BOLD}${R_code_folder}${END_C}${L_YELL} already exists,${END_C}"
		do_rm=y                      # In batch mode => Default is Yes
		echo -e -n "${GREEN}Would you like to delete it ($ rm -fr ${R_code_folder}), and clone the repository once again ? ${END_C}"
		[[ -t 0 ]] &&                  # If tty => prompt the question
		read -n 1 -p $'(Y/n) ' do_rm
		echo
		if [[ ${do_rm} =~ ^(y|Y|)$ ]]  # Do if 'y', 'Y' or empty
		then
			print_and_do "rm -fr ${R_code_folder}"
		else
			exit
		fi
	fi
	create_if_non_existent ${R_code_folder}
	echo -e "${L_CYAN}Downloading R sources from GitHub ...${END_C}"
	print_and_do "git clone ${breeze_r_code_repo_url} ${R_code_folder}/"
else
	echo -e "${RED}You don't have a public SSH key, please create it (or re-run init.sh) and add it to GitHub${END_C}"
	exit
fi
