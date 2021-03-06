#!/bin/bash
local_root_path=$(readlink -f $(dirname "$0"))
source $local_root_path/run_conf.sh

function conditional_ssh_start(){
	if [ "1" -eq $ssh_enabled ]; then
		echo -e $SHDOL"./start_ssh-tunnel.sh" && ./start_ssh-tunnel.sh
	fi
	return 0
}

echo -e $L_CYAN"Running / starting all containers..."$END_C \
"(any already running container will be killed and removed, except for MySql container)"
echo -e "N.B. If you intend to use Breeze-DB you need to run $breezedb_folder/start_mysql.sh beforehand"$END_C
# chain run the 5 docker containers
echo -e $SHDOL"./start_mysql.sh" && ./start_mysql.sh && \
echo -e $SHDOL"./start_ssh-tunnel.sh" && ./start_ssh-tunnel.sh && \
echo -e $SHDOL"./start_shiny.sh" && ./start_shiny.sh && \
echo -e $SHDOL"./start_django.sh" && ./start_django.sh && \
echo -e $SHDOL"./start_nginx.sh" && ./start_nginx.sh && echo -e $GREEN"GENERAL SUCCESS"$END_C && exit 0
echo "something went wrong, system state is lickly to be inconsistent"
echo -e $RED"FAILURE"$END_C
exit 1
# TODO should wait for django to get started befor triggering  next
# echo -e $SHDOL"$breezedb_folder/start_mysql.sh" && $breezedb_folder/start_mysql.sh && \
# TODO
# docker logs breeze-one | tail -n 1
# System is up and running, All checks done ! (successful : 4/4)
