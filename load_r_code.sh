#!/usr/bin/env bash
local_root_path=$(readlink -f $(dirname "$0"))
source ${local_root_path}/run_conf.sh

# echo -e "${GREEN}Be sure to have register the ssh public key  (~/.ssh/id_rsa.pub) into GitHub deploy keys of ${breeze_r_code_repo_name} repository before running this script.${END_C}"
if [ -f ~/.ssh/id_rsa.pub ]; then
	echo -e "${L_CYAN}Downloading R sources from GitHub ...${END_C}"
	print_and_do "git clone ${breeze_r_code_repo_url} ${local_root_path}/breeze_data/code/"
else
	echo -e "${RED}You don't have a public SSH key, please create it (or re-run init.sh) and add it to GitHub${END_C}"
	exit
fi
