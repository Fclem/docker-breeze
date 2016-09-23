#!/bin/bash
source run.conf

docker run --name $mysql_cont_name \
	-e MYSQL_ROOT_PASSWORD=$mysql_secret \
	-v $local_root_path/breeze.sql:/docker-entrypoint-initdb.d/breeze.sql \
	--restart=on-failure \
	-d $mysql_image

mysql_ip=""
if hash mysql 2>/dev/null; then
	# if mysql CLI exists, we display the list of DATABASE for the user to check if breezedb was successfully created or not
	# mysql -h 172.17.0.2 -u root -p$mysql_secret -e 'SHOW DATABASES;'
	while [ -z $mysql_ip]; do
		echo -ne "waiting for $mysql_cont_name ip adress...\033[0K\r"
		mysql_ip=`docker inspect $mysql_cont_name | grep IPAddress | grep -v null| cut -d '"' -f 4 | head -1`
		sleep 1
	done
	echo "mysql_ip:"$mysql_ip";"

	secs=$((1 * 60))
	last_ret=1
	while [ $secs -gt 0 ] && [ $last_ret -eq 1 ]; do
	   echo -ne "waiting $secs sec for the initialisation of the database...\033[0K\r"
	   sleep 1
	   : $((secs--))
	   db_list=`mysql -h $mysql_ip -u root -p$mysql_secret -e 'SHOW DATABASES;' 2>/dev/null;`
	   last_ret=$?
	done
	
	echo $db_list
	# mysql_ip=`docker inspect $mysql_cont_name | grep IPAddress | grep -v null| cut -d '"' -f 4 | head -1`
	# echo "mysql_ip:"$mysql_ip";"
	# mysql -h $mysql_ip -u root -p$mysql_secret -e 'SHOW DATABASES;'
fi
