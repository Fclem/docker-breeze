#!/bin/bash
# chain run the 3 docker containers
./my_sql.sh && ./django.sh && ./nginx.sh && exit 0
