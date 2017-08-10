#!/usr/bin/env bash

# source <(curl -L https://goo.gl/VLroxR)

git clone https://github.com/Fclem/docker-breeze.git dockerb && cd dockerb && exec ./init.sh && rm ../bootstrap.sh
