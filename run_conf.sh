local_root_path=$(readlink -f $(dirname "$0"))
source docker_breeze_img/build.conf
source const.sh
source ${local_root_path}/const.sh
source ${local_root_path}/docker_breeze_img/build.conf

# GIT
git_repo="${git_url_base}/${git_user_name}/${git_repo_name}.git"
breeze_static_repo_url="${git_url_base}/${git_user_name}/${breeze_static_repo_name}.git"
breeze_r_code_repo_url="${git_ssh_url}/${breeze_r_code_repo_name}.git"

cd ${local_root_path}
 # FOLDER STRUCTURE
nginx_folder="${local_root_path}/nginx"
nginx_template_file="${nginx_folder}/nginx_template.conf"
nginx_conf_file="${nginx_folder}/nginx.conf"
ssh_folder="${local_root_path}/.ssh/"
code_folder="${local_root_path}/code" # the root folder of your code (i.e. the one that has requirement.txt)
rel_actual_code_folder="../${git_repo_name}"
actual_code_folder=`readlink -f ${rel_actual_code_folder}`
# the breeze project folder (i.e. the one that contains the db/ folder, and the code/ for R code)
# project_folder moved to const.sh with user input
project_folder_default="${local_root_path}/breeze_data"
db_folder="${project_folder}/db"
report_cache_folder="${db_folder}/reports/_cache"
rel_static_source_path="../${static_source_name}"
static_source_path=`readlink -f ${rel_static_source_path}`
docker_root_folder="$home_folder/code"
breeze_secrets_folder="${code_folder}/configs"
shiny_folder=`readlink -f ${rel_shiny_folder}`
shiny_log_folder="${shiny_folder}/.log"
shiny_serv_folder="${shiny_folder}/shiny"
shiny_app_folder="${shiny_serv_folder}/breeze"
shiny_pub_folder="${shiny_serv_folder}/pub"
shiny_ln="${local_root_path}/shiny"
breezedb_folder=`readlink -f ${rel_breezedb_folder}`

shiny_folder_list="${shiny_folder} ${shiny_log_folder} ${shiny_serv_folder} ${shiny_app_folder} ${shiny_pub_folder}"

folders_to_create="${db_folder} ${project_folder}/code \
${db_folder}/configs ${db_folder}/datasets ${db_folder}/jobs ${db_folder}/mould \
${db_folder}/pipelines ${report_cache_folder} ${db_folder}/scripts ${db_folder}/shinyReports \
${db_folder}/shinyTags ${db_folder}/swap ${db_folder}/upload_temp \
${db_folder}/configs/engine ${db_folder}/configs/exec ${db_folder}/configs/target"

source ssh_enabled.sh

FQDN=`hostname -f`
site_name_auto=`hostname`
# site_domain=""
site_domain_in=""
FQDN_TXT=""
PUB_IP=`curl ipinfo.io/ip 2>/dev/null`

if [ -f ${mysql_secret_file} ]; then
	mysql_secret=`cat ${mysql_secret_file}`
else
	mysql_secret=''
fi
breeze_image=${repo_name}/${img_name}
full_img_name=${repo_name}/${img_name} # change image name here

# TODO FIXME use docker-compose or else

# Optional ssh bridge link and fs mount options
ssh_sup_fs="-v ${ssh_folder}:/root/.ssh/"
ssh_sup_link=""
if [ "1" -eq ${ssh_enabled} ]; then
	ssh_sup_link="--link ${ssh_cont_name}:${ssh_cont_name}"
else
	ssh_cont_name=''
	ssh_image=''
fi

# Optional Breeze-DB link
docker inspect ${breezedb_cont_name} >/dev/null 2>/dev/null
has_breezedb=$?
breezedb_sup_link=''
if [ "0" -eq ${has_breezedb} ]; then
	breezedb_sup_link="--link ${breezedb_cont_name}:${breezedb_cont_name}"
fi

# list of containers names, and images names
disposable_containers_list="$nginx_cont_name $breeze_cont_name $ssh_cont_name $ssh_cont_name"
containers_list="$disposable_containers_list $mysql_cont_name"
image_list="$shiny_image $mysql_image $breeze_image $ssh_image"

# file system mounting param for django/breeze : code folder, project folder, and setting the working folder # , and ssh config
fs_param="-v $code_folder:$docker_root_folder \
	-v $static_source_path:$home_folder/$static_source_name \
	-v $project_folder/:$docker_project_folder \
	$ssh_sup_fs \
	-w $docker_root_folder"

# linking param for django/breeze : the db container, the ssh port fw container
link_param="--link $mysql_cont_name:mysql \
	--link $mysql_cont_name:$mysql_cont_name \
	--link $shiny_cont_name:$shiny_cont_name \
	$breezedb_sup_link	$ssh_sup_link"

# file system mounts for shiny apps and logs
shiny_param="-v ${shiny_serv_folder}/:${shiny_container_folder} \
    -v ${shiny_log_folder}/:/var/log/"

# file system mounts and containers links for nginx
nginx_param="-v $nginx_folder/:/root:ro \
	-v $nginx_conf_file:/etc/nginx/nginx.conf:ro \
	-v $static_source_path/:$nginx_static_mount:ro \
	-v $report_cache_folder/:$nginx_report_cache_mount:ro \
	--link $breeze_cont_name:$breeze_cont_name \
	--link $shiny_cont_name:$shiny_cont_name"
# --link $breezedb_cont_name:breeze.northeurope.cloudapp.azure.com
