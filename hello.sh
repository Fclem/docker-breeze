#!/bin/bash

nom=`hostname`

if [ $nom != "breeze-pharma" ]
then
	# ls -la /projects/
	# echo "*************************************************************************************************************"
	KRB5CCNAME="FILE:$HOME/.krb5.ccache"
	export KRB5CCNAME
	echo "hostname: $nom"
	echo "whoami"
	whoami
	echo "CCACHE:"
	echo $CCACHE
	echo "klist"
	klist
	echo "ls -la /fs/projects/breeze-ph2"
	ls -la /fs/projects/breeze-ph2
	#echo "*************************************************************************************************************"
	#du -h /projects/
	echo "*************************************************************************************************************"
	echo "du -h /fs/projects/breeze-ph2"
	du -h /fs/projects/breeze-ph2
	echo "*************************************************************************************************************"
else
	export SGE_ROOT=/var/lib/gridengine/
	export PATH=$PATH:/usr/lib/gridengine/
	echo "config OK"
fi
# sleep 120

