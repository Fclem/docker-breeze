#!/bin/bash
local_root_path=$(readlink -f $(dirname "$0"))

echo -e $SHDOL"$local_root_path/stop_all.sh"
$local_root_path/stop_all.sh && echo -e $SHDOL"$local_root_path/start_all.sh" && $local_root_path/start_all.sh && exit 0
exit 1
