#!/usr/bin/env bash
local_root_path=$(readlink -f $(dirname "$0"))
source const.sh # IDE hack for var resolution
source ${local_root_path}/const.sh

# clem 10/08/2017
function gen_nginx_conf(){
	# small templating engine that reads NGINX configuration template and replaces any %var_name% by the content of
	# the corresponding ${var_name}
	# inspired from https://stackoverflow.com/a/26509635/5094389 by wich (https://stackoverflow.com/users/251414/wich)
	echo -e $L_CYAN"Generating NGINX configuration file from template ..."${END_C}
	old_IFS=$IFS
	IFS=$'\n'
	echo "" > ${nginx_conf_file}
	regex="%(\w+?)%"
	for line in `cat ${nginx_template_file}`; do
		if [[ "$line" =~ $regex ]]
		then
			name="${BASH_REMATCH[1]}"
			name="${name}"
			line=${line//${BASH_REMATCH[0]}/${!name}}
			if [ "${!name}" = "" ]; then
				echo -e "${RED}ERROR: ${BOLD}${name}${END_C}${RED} WAS NOT SET${END_C}" >> /dev/stderr
			fi
		fi
		echo $line >> ${nginx_conf_file}
	done
	IFS=$old_IFS
	# delete the template
	# print_and_do "rm ${nginx_template_file}"
}

# clem 10/08/2017
function check_sudo(){
	echo -e "${L_CYAN}Checking for root access ${END_C}(if prompted please enter the root password)${L_CYAN} ...${END_C}"
	sudo echo -e "${GREEN}OK${END_C}"
}

function create_folders_if_not_existant(){
	for var in "$@"
	do
		if [ ! -d "$var" ] ; then
			mkdir -p $var && print_created $var
		else
			print_already $var
		fi
	done
}

### check sudo access
check_sudo

### check if user is in docker group, adds it if not
username=${USER}
if getent group docker | grep &>/dev/null "\b${username}\b"; then
	echo -n -e "${L_YELL}${username} already in group docker"${END_C}
else
	print_and_do "sudo groupadd docker && sudo usermod -aG docker ${username}"
	echo -e "${L_YELL}${username} added to group docker, please log in again, and run " \
		"'${BOLD}cd dockerb && ./init${END_C}${L_YELL}'"${END_C}
	logout 2>/dev/null
	exit
fi

### load config files
source ${local_root_path}/init_ssh.sh # will ask if should be enabled or not
source run_conf.sh # IDE hack for var resolution
source ${local_root_path}/run_conf.sh

echo -e ${GREEN}"Enter the path for the project folder on this host (NO trailling slash)${END_C}"
echo -n -e ${GREEN}"leave blank for default ${BOLD}${project_folder_default}${END_C}${GREEN} : ${END_C}"
read project_folder_input
if [ "${project_folder_input}" != "" ]; then
	# create_if_non_existent ${project_folder_input}
	project_folder=${project_folder_input}
else
	project_folder=${project_folder_default}
fi
# saves the folder path in const.sh
print_and_do "echo \"project_folder='${project_folder}'\">>${local_root_path}/const.sh"
# reloads configs
source ${local_root_path}/run_conf.sh

###
#  Gather all required information from user so that the script does not require later attending :
###

###
### run_mode ?
###
run_mode=''
# trying to autodetect based on FQDN
run_sup=''
run_mode_auto=''
if printf -- '%s' "${FQDN}" | egrep -q -- "breeze-dev"
then # dev
	run_mode_auto="${run_mode_dev}"
else
	if printf -- '%s' "${FQDN}" | egrep -q -- "breeze-ph"
	then
		run_mode_auto="${run_mode_pharma}"
	else
		run_mode_auto="${run_mode_prod}"
	fi
fi
run_sup="(default to ${BOLD}${run_mode_auto}${END_C}) "
function ask_run_mode(){
	choose_line="${GREEN}Choose a run-mode between ${END_C} ${run_mode_prod} | ${run_mode_dev} | ${run_mode_pharma} |  ${run_mode_ph_dev} ${run_sup}: "
	echo -n -e "${choose_line}"
	read run_mode
}
ask_run_mode
# fill with auto-detected value if input is null
if [ "${run_mode_auto}" != "" ] && [ "${run_mode}" = "" ]; then
	run_mode="${run_mode_auto}"
fi
# check if properly filled
while [ "${run_mode}" != "${run_mode_dev}" ] && [ "${run_mode}" != "${run_mode_pharma}" ] && \
 [ "${run_mode}" != "${run_mode_ph_dev}" ] && [ "${run_mode}" != "${run_mode_prod}" ]
do
	echo -e  ${RED}"Invalid run-mode"${END_C}" '${run_mode}'"
	ask_run_mode
done

###
### run_env ?
###
run_env=''
# trying to autodetect based on FQDN
env_sup=''
run_env_auto=''
if printf -- '%s' "${FQDN}" | egrep -q -- "cloudapp.net"
then # Azure
	run_env_auto="${env_azure}"
	env_sup="(default to ${BOLD}${run_env_auto}${END_C}) "
else
	if printf -- '%s' "${FQDN}" | egrep -q -- "gui.fi"
	then
		run_env_auto="${env_fimm}"
		env_sup="(default to ${BOLD}${run_env_auto}${END_C}) "
	fi
fi
# ask the user
function ask_run_env(){
	choose_line="${GREEN}Choose a run-environement between ${END_C} ${env_azure} | ${env_fimm} ${env_sup}: "
	echo -n -e "${choose_line}"
	read run_env
}
ask_run_env
# fill with auto-detected value if input is null
if [ "${run_env_auto}" != "" ] && [ "${run_env}" = "" ]; then
	run_env="${run_env_auto}"
fi
# check if properly filled
while [ "${run_env}" != "${env_azure}" ] && [ "${run_env}" != "${env_fimm}" ]
do
	echo -e  ${RED}"Invalid run-environement"${END_C}" '${run_env}'"
	ask_run_env
done

###
### Should download code repo from github ?
###
if [ ! "$(ls -A ${actual_code_folder} 2>/dev/null)" ]; then
	do_git_clone=y                      # In batch mode => Default is Yes
	echo -n -e ${GREEN}"\nWould you like to clone ${BOLD}${git_repo}${END_C}${GREEN} repository into ${BOLD}${actual_code_folder}${END_C}${GREEN} folder ? "${END_C}
	[[ -t 0 ]] &&                  # If tty => prompt the question
	read -n 1 -p $'(Y/n) ' do_git_clone
	echo
fi

###
### FQDN / host configuration (useful for site table in db, and nginx conf file)
###
if [ "" != "${FQDN}" ]; then
	echo -e ${GREEN}"Auto-detected FQDN : ${END_C}${BOLD}${FQDN}${END_C}"
	FQDN_TXT="(leave blank for auto-detected one) "
fi
while [[ -z "${site_domain// }" ]]
do
	echo -n -e ${GREEN}"Enter the FQDN of this host ${FQDN_TXT}: "${END_C}
	read site_domain_in
	if [[ -z "${site_domain_in}" ]]; then
		site_domain="${FQDN}"
	else
		site_domain="${site_domain_in}"
	fi
done
# Check if FQDN resolve to this public ip
FQDN_IP=`dig +short ${site_domain}`
if [ "$FQDN_IP" != "${PUB_IP}" ]; then
	echo -e ${RED}"WARNING: FQDN does not resolve to this server public ip (${PUB_IP})"${END_C}
	# TODO else write FQDN and PUB_IP in a file to passon to Breeze
else
	echo -e ${BOLD}"${site_domain}${END_C}${GREEN} resolves to this server's public IP (${PUB_IP}) !"${END_C}
fi

###
### Site name
###
# auto-detect site_name from local hostname
site_name_sup=''
if [ "${site_name_auto}" != "" ]; then
	site_name_sup=", default to ${BOLD}${site_name_auto}${END_C}${GREEN}"
fi
while [ "${site_name}" = "" ]
do
	echo -n -e ${GREEN}"Enter the name of this site (no space${site_name_sup}) : ${END_C}"
	read site_name
	if [ "${site_name_auto}" != "" ] && [ "${site_name}" = "" ]; then
		site_name=${site_name_auto}
	fi
done

###
### Creating SSH keys if non-existant
###
if [ ! -f ~/.ssh/id_rsa.pub ]; then
	print_and_do "sudo chmod g+w ~/.ssh && sudo chown root:${username} ~/.ssh"
	echo -e ${L_CYAN}"Creating SSH keys ..."${END_C}
	print_and_do "ssh-keygen -t rsa -b 4096 -C \"${site_name}@${site_domain}\""
fi

echo
echo -e ${L_CYAN}"Init will now run fully unattended, and might take several minutes to complete"${END_C}
echo "You should scroll through the log to make sure that everything goes smoothly"
echo

###
#  END OF ATTENDED PART
###

### Fix locale
sudo locale-gen ${locale_gen}
export LANGUAGE=${locale_gen}
export LANG=${locale_gen}
export LC_ALL=${locale_gen}
sudo locale-gen ${locale_gen}
# FIXME some issues with that and root rights...
sudo echo "${time_zone}" > /etc/timezone && \
	sudo dpkg-reconfigure -f noninteractive tzdata && \
	sed -i -e "s/# ${locale_gen} UTF-8/${locale_gen} UTF-8/" /etc/locale.gen && \
	sudo echo "LANG=\"${locale_gen}\"">/etc/default/locale && \
	sudo dpkg-reconfigure --frontend=noninteractive locales && \
	sudo update-locale LANG=${locale_gen}
### APT update
print_and_do "sudo apt-get update && sudo apt-get upgrade -y"
print_and_do "sudo apt-get install apt-transport-https ca-certificates"
### Get docker repos keys
print_and_do "sudo apt-key adv \
			--keyserver ${apt_docker_key_server} \
			--recv-keys ${apt_docker_key_id}"
### Add apt docker repo
print_and_do "echo 'deb ${apt_docker_repo} ubuntu-xenial main' "\
"| sudo tee /etc/apt/sources.list.d/docker.list"
print_and_do "sudo apt-get update"
### installs required packages from list
inst_list=`cat VM_pkg_list`
print_and_do "sudo apt-get install -y linux-image-extra-$(uname -r) ${inst_list}"
print_and_do "sudo gpasswd -a ${USER} docker" # FIXME useless
print_and_do "sudo service docker start"
### creates mysql password file if absent
if [ ! -f ${mysql_secret_file} ]; then
	touch ${mysql_secret_file} && \
	chmod go-rwx ${mysql_secret_file} && \
	echo -e ${L_CYAN}"Created mysql password file '${mysql_secret_file}'."${END_C}
	rnd_pass=`pwqgen random=85`
	echo ${rnd_pass} > ${mysql_secret_file}
	rnd_pass=''
	mysql_secret=`cat ${mysql_secret_file}`
fi
### Folder structure creation
# TODO improve & finnish. Make a python shell script instead ?
echo -e ${L_CYAN}"Creating file and folder structure ..."${END_C}
# create empty files for easier bash competition when using docker start/attach etc.
touch ${containers_list}
chmod ugo-rwx ${containers_list}
# if project folder is different than default, makes a soft link for default to actual path
if [ "${project_folder}" != "${project_folder_default}" ]; then
	# makes sure target folder is writable
	# project_target=$(readlink -f $(dirname "${project_folder}"))
	print_and_do "sudo chmod g+w ${project_folder} && sudo chown root:${username} ${project_folder}"
	# deletes the default project folder with error suppression, for if non existent
	print_and_do "rm -f ${project_folder_default} 2>/dev/null"
	print_and_do "ln -s ${project_folder} ${project_folder_default}"
fi
# creates project folder if non existant
create_folders_if_not_existant ${folders_to_create}
# creates code folder if non existent
create_if_non_existent "${actual_code_folder}"
# creates shiny folder if non existent
create_if_non_existent "${shiny_folder}" ${shiny_folder_list}
# soft link for shiny folder
print_and_do "ln -s ${rel_shiny_folder} ${shiny_ln}"
# if code folder is empty, offer to clone isbio repo
if [ "$(ls -A ${actual_code_folder} 2>/dev/null)" ]; then
	echo -e ${L_YELL}"${actual_code_folder} is not empty, if you which to clone isbio into it, clear it first"${END_C}
else
	if [[ ${do_git_clone} =~ ^(y|Y|)$ ]]  # Do if 'y', 'Y' or empty
	then
		print_and_do "git clone ${git_repo} ${actual_code_folder}"
	fi
	# create a softlink to the code repo tld
	if [ ! -d "${actual_code_folder}" ] ; then
		print_and_do "ln -s ${actual_code_folder} ${code_ln}"
	fi
	# create the secrets folder
	print_and_do "mkdir ${breeze_secrets_folder} 2>/dev/null"
	if [ ! -f ${breeze_secrets_folder}/${mysql_secret_file} ]; then
		# print_and_do "rm ${breeze_secrets_folder}/${mysql_secret_file} 2>/dev/null"
		# create hard links for mysql passd
		# FIXME may be overwritten while db already created
		print_and_do "ln ${mysql_secret_file} ${breeze_secrets_folder}/${mysql_secret_file}"
	fi
fi
# just in case
chmod ugo+r breeze.sql
# save the run mode in .run_mode into the code folder
print_and_do "echo '${run_mode}'>${actual_code_folder}/.run_mode"
# save the run env in .run_env into the code folder
print_and_do "echo '${run_env}'>${actual_code_folder}/.run_env"
### getting devlopers GPG keys for pipeline source code, and breeze git auto-update code signature authentication
echo -e ${L_CYAN}"Getting devs' GPG public keys ..."${END_C}
print_and_do "gpg --keyserver ${GPG_key_server} --recv ${clem_GPG_id}"
print_and_do "gpg --keyserver ${GPG_key_server} --recv ${alks_GPG_id}"
# Add the site to the SQL conf file
sql_line="INSERT INTO \\\`django_site\\\` SET \\\`domain\\\`='${site_domain}', \\\`name\\\`='${site_name}';"
print_and_do "echo \"${sql_line}\" >> ${mysql_init_file}"
### Get the static content from the github repo
echo -e ${L_CYAN}"Getting static content ..."${END_C}
print_and_do "git clone ${breeze_static_repo_url} ${static_source_path}"
# create a soft link to the static source folder
print_and_do "ln -s ${rel_static_source_path} ${code_folder}/${static_source_name}"
### Generate the nginx config file
gen_nginx_conf
### set fish as the default shell
sudo chsh -s /usr/bin/fish ${username}
sudo chsh -s /usr/bin/fish # also for root user
### Get the DOCKER images
echo -e ${L_CYAN}"Getting docker images ..."${END_C}
print_and_do "docker pull ${shiny_image}" # this is an un-edited copy of default docker shiny image
print_and_do "docker pull ${mysql_image}" # this is an un-edited copy of default docker mysql image
print_and_do "docker pull nginx" # this is an un-edited copy of default docker mysql image
docker pull ${breeze_image} && echo -e ${L_CYAN}"Breeze docker image have been downloaded from dockerhub.
"${L_YELL}"You can also customize it and build it from ${BOLD}./docker_breeze_img/"${END_C}
###
#  DONE
###
echo -e ${BOLD}"N.B. before starting Breeze :"${END_C}
echo -e " _ Copy req. secrets to ${BOLD}${breeze_secrets_folder}${END_C} or use ./init_secret.sh (TODO automatize)"
echo -e " _ Add the SSL certificates to ${BOLD}${nginx_folder}${END_C}"
echo -e " _ Add the following SSH key to GitHub to be able to download R sources then run ${BOLD}./load_r_code.sh${END_C}"
echo -e " _ if you'd like to restore any data into MySql, just store SQL query into ${BOLD}restore.sql${END_C} and they will be executed right after DB init"
echo -e " _ if using Breeze-DB you need to copy appropriated files to ${BOLD}${breezedb_folder}${END_C}, and run"\
" ${BOLD}${breezedb_cont_name}${END_C} container ${BOLD}before${END_C} running Breeze"
echo -e ${BOLD_GREEN}"To start breeze, run './start_all.sh'"${END_C}
echo "THE SSH KEY :"
cat ~/.ssh/id_rsa.pub
echo -e ${GREEN}"DONE"${END_C}
fish
