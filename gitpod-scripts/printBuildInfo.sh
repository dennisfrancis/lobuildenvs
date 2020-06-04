#!/bin/bash

REPODIR=${REPODIR-core}

WORKSPACE="/workspace"
COREROOT="${WORKSPACE}/${REPODIR}"
MAKEROOTPID=$(ps aux | grep build-nocheck | grep -v grep | awk '{print $2}')

echo ""

if [ -z $MAKEROOTPID ]
then
	echo "Build status : No build in progress"
else
	TZ=Asia/Kolkata ps -p ${MAKEROOTPID} -o pid,cmd,etime,lstart
fi

echo ""
echo "core.git build space usage"
du -sh ${COREROOT}/workdir ${COREROOT}/instdir

echo ""
echo "free -h"
free -h

echo ""
echo "clang processes"
pgrep -l clang

