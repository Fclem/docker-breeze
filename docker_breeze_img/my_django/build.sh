#!/bin/bash

source build.conf

((version++))

docker build -t $repo_name/$img_name .
echo ${version}>.version
docker tag $repo_name/$img_name $repo_name/$img_name:$tag$version
docker images $repo_name/$img_name
