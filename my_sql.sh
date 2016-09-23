#!/bin/bash
source run.conf

docker run --name $mysql_cont_name \
	-e MYSQL_ROOT_PASSWORD=$mysql_secret \
	-v $local_root_path/breeze.sql:/docker-entrypoint-initdb.d/breeze.sql \
	--restart=on-failure \
	-d $mysql_image

echo "waiting 30 sec for the initialisation of the database..."

sleep 30

if hash mysql 2>/dev/null; then
	# if mysql CLI exists, we display the list of DATABASE for the user to check if breezedb was successfully created or not
	mysql_ip=`docker inspect $mysql_cont_name | grep IPAddress | grep -v null| cut -d '"' -f 4 | head -1`
	echo "mysql_ip:"$mysql_ip";"
	mysql -h $mysql_ip -u root -p$mysql_secret -e 'SHOW DATABASES;'
fi
