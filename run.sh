#!/bin/bash
# chain run the 3 docker containers
echo "./my_sql.sh" && ./my_sql.sh && \
echo "./django.sh" && ./django.sh && \
echo "./nginx.sh" && ./nginx.sh && exit 0
