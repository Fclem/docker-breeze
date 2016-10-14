#!/bin/bash
source run.conf

echo -e $L_CYAN"Running / starting all containers..."$END_C \
"(any already running container will be killed and removed, except for MySql container)"
# chain run the 4 docker containers
echo "./my_sql.sh" && ./my_sql.sh && \
echo "./ssh-fw.sh" && ./ssh-fw.sh && \
echo "./django.sh" && ./django.sh && \
echo "./nginx.sh" && ./nginx.sh && echo -e $GREEN"GENERAL SUCCESS"$END_C && exit 0
echo "something went wrong, system state is lickly to be inconsistent"
echo -e $RED"FAILURE"$END_C
exit 1

# docker logs breeze-one | tail -n 1
# System is up and running, All checks done ! (successful : 4/4)
