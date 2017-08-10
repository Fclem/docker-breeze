#!/usr/bin/env bash

# curl https://goo.gl/VLroxR && ./bootstrap.sh

git clone https://github.com/Fclem/docker-breeze.git dockerb && cd dockerb && exec ./init.sh && rm ../bootstrap.sh
