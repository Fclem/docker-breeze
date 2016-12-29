#!/bin/bash
local_root_path=$(readlink -f $(dirname "$0"))
source $local_root_path/run_conf.sh

if [ "0" -eq $has_breezedb ]; then
	echo -e $L_CYAN"Breeze-bio-db is enabled"$END_C
	echo -e $SHDOL"$breezedb_folder/start_mysql.sh" &&	$breezedb_folder/start_mysql.sh
else
	echo -e $L_CYAN"Breeze-bio-db is DISABLED"$END_C
fi
