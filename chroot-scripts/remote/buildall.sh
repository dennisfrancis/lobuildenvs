#!/bin/bash

source ./envvars.sh

BUILDALL_LOG=${WORKSPACE}/buildall.log
BUILDALL_DONE=${WORKSPACE}/buildall.success
BUILDALL_FAILED=${WORKSPACE}/buildall.failed
BUILDALL_RUNNING=${WORKSPACE}/buildall.running

rm -f ${BUILDALL_DONE}
rm -f ${BUILDALL_FAILED}
rm -f ${BUILDALL_RUNNING}

touch ${BUILDALL_RUNNING}

# Build core
cd ${COREDIR} && TZ=Asia/Kolkata echo "[$(date)] Building core..." > ${BUILDALL_LOG} 2>&1
(./autogen.sh && make build-nocheck) > ${CORE_BUILD_LOG} 2>&1
if [ $? -eq 0 ]
then
    TZ=Asia/Kolkata echo "[$(date)] Finished building core." >> ${BUILDALL_LOG} 2>&1
else
    TZ=Asia/Kolkata echo "[$(date)] Core build failed!" >> ${BUILDALL_LOG} 2>&1
    rm -f ${BUILDALL_RUNNING}
    touch ${BUILDALL_FAILED}
    exit -1
fi

# Build online
cd ${ONLINEDIR} && TZ=Asia/Kolkata echo "[$(date)] Building online..." >> ${BUILDALL_LOG} 2>&1
if [ $? -eq 0 ]
then
    TZ=Asia/Kolkata echo "[$(date)] Finished building online." >> ${BUILDALL_LOG} 2>&1
    rm -f ${BUILDALL_RUNNING}
    touch ${BUILDALL_DONE}
else
    TZ=Asia/Kolkata echo "[$(date)] Online build failed!" >> ${BUILDALL_LOG} 2>&1
    rm -f ${BUILDALL_RUNNING}
    touch ${BUILDALL_FAILED}
    exit -1
fi

echo "SUCCESS" >> ${BUILDALL_LOG}