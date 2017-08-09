# helpers
username=${USER}
END_C="\e[0m"
RED="\e[91m"
L_CYAN="\e[96m"
BOLD_GREEN="\e[1;32m"
L_YELL="\e[93m"
GREEN="\e[32m"
BOLD="\e[1m"
SHDOL=${GREEN}${BOLD}"$"${END_C}" "

# # # # # # # #
# env defined #
# # # # # # # #
git_repo_name="isbio2"

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

# FOLDER STRUCTURE CONFIGS
static_source_name='static_source'
home_folder="/root"
docker_project_folder="/projects/breeze"
rel_shiny_folder="../shiny/"
rel_breezedb_folder="../breeze-db/"
code_ln="code"

# RUN MODES
run_mode_dev='dev'
run_mode_pharma='pharma'
run_mode_ph_dev='pharma_dev'
run_mode_prod='prod'

# ENV CONFS
env_azure='azurecloud'
env_fimm='fimm'
