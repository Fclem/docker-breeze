#!/bin/bash

echo "./stop_all.sh"
./stop_all.sh && echo "./run.sh" && ./run.sh && exit 0
exit 1
