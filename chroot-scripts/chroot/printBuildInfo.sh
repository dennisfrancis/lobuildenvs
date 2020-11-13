#!/bin/bash

source ../envvars.sh

MAKEROOTPID=$(pgrep -a make | head -1 | cut -f 1 -d' ')

if [ -z $MAKEROOTPID ]
then
	echo "Build status : No builds in progress"
else
	echo "Build status : Builds in progress"
fi

echo ""
echo "core.git build space usage"
du -sh ${COREDIR}/workdir ${COREDIR}/instdir
echo "online.git build space usage"
du -sh ${ONLINEDIR}/

echo ""
free -h

echo ""
echo "clang processes"
pgrep -l clang

true
