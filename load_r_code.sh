local_root_path=$(readlink -f $(dirname "$0"))
source const.sh # IDE hack for var resolution
source ${local_root_path}/const.sh

echo -e "${GREEN}Be sure to have register the ssh public key  (~/.ssh/id_rsa.pub) into GitHub deploy keys of ${breeze_r_code_repo_name} repository before running this script.${END_C}"
git clone ${breeze_r_code_repo_url} ${local_root_path}/breeze_data/code/
