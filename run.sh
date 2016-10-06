#!/bin/bash
# chain run the 3 docker containers
echo "./my_sql.sh" && ./my_sql.sh && \
echo "./django.sh" && ./django.sh && \
echo "./nginx.sh" && ./nginx.sh && exit 0

# docker logs breeze-one | tail -n 1
# System is up and running, All checks done ! (successful : 4/4)
