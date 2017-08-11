#!/bin/bash
local_root_path=$(readlink -f $(dirname "$0"))
source $local_root_path/run_conf.sh

failure_text="MYSQL CONTAINER INIT FAILURE :"
check_log_text="It seems breeze DB was not loaded into mysql, c.f. container log"

echo -e $L_CYAN"Running MySql container $mysql_cont_name"$END_C

# check if container already exsits (data persistance)
docker inspect $mysql_cont_name > /dev/null 2>/dev/null
if [ $? -eq 1 ]; then
	# check if there is a restore file
	mysql_restore_sup=''
	if [ -f $local_root_path/restore.sql ]; then
		mysql_restore_sup="-v $local_root_path/restore.sql:/docker-entrypoint-initdb.d/restore.sql"
	fi
	# container does not exist, we create a new one
	all_params="--name $mysql_cont_name \
		-e MYSQL_ROOT_PASSWORD=$mysql_secret \
		-v $local_root_path/breeze.sql:/docker-entrypoint-initdb.d/breeze.sql ${mysql_restore_sup} \
		--restart=on-failure \
		-d $mysql_image"

	echo -e $SHDOL"docker run $all_params"
	docker run $all_params
else
	# run the existing one
	echo -e $SHDOL"docker start $mysql_cont_name"
	docker start $mysql_cont_name
fi

if [ $? -ge 1 ]; then
	echo -e $L_YELL"Unable to run/start $mysql_cont_name"$END_C
	echo -e $RED"FAILURE"$END_C
	exit 1
fi

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
		echo -e $RED"FAILURE"$END_C
		exit 1
	else
		echo -ne "waiting 2 more seconds...\033[0K"
		sleep 2
		echo -ne "\r"
	fi
else
	echo -e $L_YELL"cannot check if DB is properly setup, since there is no local mysql client"$END_C
fi
echo -e $GREEN"SUCCESS"$END_C
exit 0
