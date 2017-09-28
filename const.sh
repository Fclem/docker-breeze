# bash coloring helpers
username=${USER}
END_C="\e[0m"
RED="\e[91m"
L_CYAN="\e[96m"
BOLD_GREEN="\e[1;32m"
L_YELL="\e[93m"
GREEN="\e[32m"
BOLD="\e[1m"
SHDOL=${GREEN}${BOLD}"$"${END_C}" "

function print_and_do(){
	echo -e $SHDOL$1
	eval $1
}

# # # # # # # #
# env defined #
# # # # # # # #

# GIT
git_url_base="https://github.com"
git_user_name="Fclem"
git_repo_name="isbio2"
git_ssh_url="git@github.com:${git_user_name}"
breeze_static_repo_name="breeze-static"
breeze_r_code_repo_name="DSRT-v2"

# DOCKER SOURCES
apt_docker_key_server="hkp://ha.pool.sks-keyservers.net:80"
apt_docker_key_id="58118E89F3A912897C070ADBF76221572C52609D"
apt_docker_repo="https://apt.dockerproject.org/repo"

# CONTAINERS NAMES
# empty file with these name will be created for bash auto completion while using docker start/attach etc.
ssh_cont_name='breeze-ssh'
breeze_cont_name='breeze-one'
mysql_cont_name='breeze-sql'
breezedb_cont_name='breeze-db'
nginx_cont_name='breeze-nginx'
shiny_cont_name='breeze-shiny'

# SSH RELATED CONFIGS
ssh_image='kingsquare/tunnel:forward'
ssh_user='breeze'
ssh_server='10.0.1.4'
ssh_local_port='3945'
ssh_forwarded_ip='127.0.0.1'
ssh_remote_port='4243'

# SHINY CONFIGS
shiny_container_folder='/srv/shiny-server/' # shiny's path in the container
shiny_image='fimm/shiny' # an un-edited copy of default docker shiny image

# MYSQL CONFIGS
mysql_image='fimm/mysql' # an un-edited copy of default docker mysql image
mysql_secret_file='.mysql_root_secret'
mysql_init_file='./breeze.sql'

# FOLDER STRUCTURE CONFIGS
static_source_name='static_source'
home_folder="/root"
docker_project_folder="/projects/breeze"
rel_shiny_folder="../shiny"
rel_breezedb_folder="../breeze-db"
code_ln="code"

# RUN MODES
run_mode_dev='dev'
run_mode_pharma='pharma'
run_mode_ph_dev='pharma_dev'
run_mode_prod='prod'

# ENV CONFS
env_azure='azurecloud'
env_fimm='fimm'
site_name=''
site_name_in=''
locale_gen='en_US.UTF-8'
time_zone="Europe/Helsinki"

# GPG
GPG_key_server="hkp://keyserver.ubuntu.com:80" # using port 80 prevents issues with oubound firewall
clem_GPG_id="B4A7FF8614ED9842"
alks_GPG_id="DFDAF03DA18C9EE8"

# nginx
nginx_static_base="/www/data" # user for NGINX
nginx_static_mount="${nginx_static_base}/static"
nginx_report_cache_mount="/www/data/reports/"
