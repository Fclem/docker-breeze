#!/bin/bash

echo -e $SHDOL"./stop_all.sh"
./stop_all.sh && echo -e $SHDOL"./start_all.sh" && ./start_all.sh && exit 0
exit 1
