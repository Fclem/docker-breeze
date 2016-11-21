#!/bin/bash

source run_conf.sh

function delete_confirm(){
	confirmation="N"
	echo -e $SHDOL"docker rm $disposable_containers_list"
	echo -n -e $GREEN"\nProceed with deleting the following containers ? "$END_C" $disposable_containers_list "
	[[ -t 0 ]] &&                  # If tty => prompt the question
	read -n 1 -p \
	$'(Y/n) ' confirmation
	if [[ $confirmation =~ ^(y|Y|)$ ]]  # Do if 'y', 'Y' or empty
	then
		echo -e $SHDOL"docker rm $disposable_containers_list"
		docker rm $disposable_containers_list && \
		return 0
	else
		return 0
	fi
	return 1
}

now=`date --rfc-3339=second | sed 's/ /T/'`

echo -e $SHDOL"./stop_all.sh"
./stop_all.sh && \
delete_confirm() && \
echo -e $SHDOL"docker rename $mysql_cont_name $mysql_cont_name""_$now" && \
docker rename $mysql_cont_name $mysql_cont_name"_"$now && \
echo -e $GREEN"SUCCESS"$END_C && exit 0

echo -e $RED"FAILURE"$END_C
exit 1

