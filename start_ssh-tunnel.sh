#!/bin/bash
local_root_path=$(readlink -f $(dirname "$0"))
source $local_root_path/run_conf.sh

if [ "1" -eq $ssh_enabled ]; then
	echo -e $L_CYAN"Running SSH bridge container $ssh_cont_name"$END_C

	echo "Removing any previously running $ssh_cont_name"
	docker rm -f /$ssh_cont_name

	all_params="-d --name $ssh_cont_name \
		-v $SSH_AUTH_SOCK:/ssh-agent \
		--restart=on-failure \
		$ssh_image \
		*:$ssh_local_port:$ssh_forwarded_ip:$ssh_remote_port $ssh_user@$ssh_server"

	echo -e $SHDOL"docker run $all_params"

	docker run $all_params && echo -e $GREEN"SUCCESS"$END_C && exit 0
else
	echo -e $L_CYAN"Skipping SSH bridge container, as it is disabled in config"$END_C
	exit 0
fi
echo -e $RED"FAILURE"$END_C
exit 1
# docker exec -t breeze-one python -c "import urllib2; opener = urllib2.build_opener(); print opener.open('http://breeze-ssh:3945/info', None, timeout=5).code==200"
