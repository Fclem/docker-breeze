#!/bin/bash
source run.conf

failure_text="MYSQL CONTAINER INIT FAILURE :"
check_log_text="It seems breeze DB was not loaded into mysql, c.f. container log"

docker run --name $mysql_cont_name \
	-e MYSQL_ROOT_PASSWORD=$mysql_secret \
	-v $local_root_path/breeze.sql:/docker-entrypoint-initdb.d/breeze.sql \
	--restart=on-failure \
	-d $mysql_image

# TODO check for previously existing container, and start it if stopped

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
	   list=`mysqlshow -h $mysql_ip -u root -p$mysql_secret 2>/dev/null;`
	   last_ret=$?
	done

	echo
	sleep 1
	list=`mysqlshow -h $mysql_ip -u root -p$mysql_secret 2>/dev/null | grep -v "information_schema" |grep -v "mysql" |grep -v "performance_schema" |grep -v "sys" |grep -v "Databases" |grep -v "+"`

	if [ -z "$list" ]; then
		echo -e $RED$failure_text$END_C
		echo $check_log_text" :"
		docker logs $mysql_cont_name
		echo -e $RED$failure_text$END_C
		echo  $check_log_text" above"
		docker rm -f $mysql_cont_name && echo "deleted $mysql_cont_name container"
		exit 1
	else
		sleep 5
		echo -e $GREEN"SUCCESS"$END_C
		exit 0
	fi
fi

