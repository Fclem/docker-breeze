#!/bin/bash
source run.conf

docker run --name $mysql_cont_name \
	-e MYSQL_ROOT_PASSWORD=$mysql_secret \
	-v $local_root_path/breeze.sql:/docker-entrypoint-initdb.d/breeze.sql \
	--restart=on-failure \
	-d $mysql_image

mysql_ip=""
def_db_list="Database information_schema mysql performance_schema sys"

# if mysql CLI exists, we display the list of DATABASE for the user to check if breezedb was successfully created or not
if hash mysql 2>/dev/null; then
	# wait for container to get its ip adress
	while [ -z $mysql_ip ]; do
		echo -ne "\r"
		echo -ne "waiting for $mysql_cont_name ip adress...\033[0K"
		mysql_ip=`docker inspect $mysql_cont_name | grep IPAddress | grep -v null| cut -d '"' -f 4 | head -1`
		sleep 1
	done
	# wait for mysql init
	secs=0
	last_ret=1
	while [ $last_ret -eq 1 ]; do
	   echo -ne "\r"
	   echo -ne "waited $secs sec for the initialisation of the database...\033[0K"
	   sleep 1
	   : $((secs++))
	   list=`mysql -h $mysql_ip -u root -p$mysql_secret -e 'SHOW DATABASES;' 2>/dev/null;`
	   last_ret=$?
	done
	# output DB list
	# mysql -h $mysql_ip -u root -p$mysql_secret -e 'SHOW DATABASES;' 2>/dev/null
	# echo $list
	if [ "$list" -eq "$def_db_list" ]; then
		echo -e $RED"INIT FAILURE :"$END_C
		echo "It seems breeze DB was not loaded into mysql, c.f. container log :"
		docker logs $mysql_cont_name
		docker rmi -f $mysql_cont_name
	else
		echo -e $GREEN"SUCCESS"$END_C
	fi
fi
