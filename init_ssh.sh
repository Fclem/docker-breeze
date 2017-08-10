# takes care of conditional ssh initialization
# lies in a separate files so as to provide option to enable it later
local_root_path=$(readlink -f $(dirname "$0"))
source $local_root_path/const.sh
source $local_root_path/run_conf.sh
enable_ssh="N"                      # In batch mode => Default is Yes
echo -n -e $GREEN"\nWould you like to enable ssh-tunneling (you can also do it at a later time using init_ssh.sh) ? "$END_C
[[ -t 0 ]] &&                  # If tty => prompt the question
read -n 1 -p \
$'(y/N) ' enable_ssh
echo
if [[ $enable_ssh =~ ^(y|Y)$ ]]  # Do if 'y', 'Y' or empty
then
    ssh_enabled=1
else
	ssh_enabled=0
fi
echo "ssh_enabled=$ssh_enabled" > ssh_enabled.sh
source run_conf.sh

# CONF
if [ "1" -eq $ssh_enabled ]; then
	touch $ssh_cont_name
	chmod ugo-rwx $ssh_cont_name
	./init_ssh-agent.fish
	docker pull $ssh_image
fi
