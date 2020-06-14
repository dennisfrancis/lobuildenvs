#!/bin/bash

source ../envvars.sh

MAKEROOTPID=$(pgrep -a make | grep 'build-nocheck' | cut -f 1 -d' ')

echo ""

if [ -z $MAKEROOTPID ]
then
	echo "Build status : No build in progress"
else
	TZ=Asia/Kolkata ps -p ${MAKEROOTPID} -o pid,cmd,etime,lstart
fi

echo ""
echo "core.git build space usage"
du -sh ${COREDIR}/workdir ${COREDIR}/instdir

echo ""
echo "free -h"
free -h

echo ""
echo "clang processes"
pgrep -l clang

true
