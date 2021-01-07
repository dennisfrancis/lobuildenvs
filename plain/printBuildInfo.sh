#!/bin/bash

source ./envvars.sh

MAKECOREPID=$(pgrep -a make | grep build-nocheck | head -1 | cut -f 1 -d' ')
MAKEONLINEPID=$(pgrep -a make | head -1 | cut -f 1 -d' ')

if [ -z $MAKECOREPID ] && [ -z $MAKEONLINEPID ]
then
	echo "Build status : No builds in progress"
elif [ ! -z $MAKECOREPID ]
then
	echo "Build status : Core build in progress"
else
	echo "Build status : Online build in progress"
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
