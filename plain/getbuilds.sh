#!/bin/bash

test -f ./envvars.sh || { echo "Can't access ./envvars.sh" && exit -1; }

source ./envvars.sh

rm -f ${GETBUILDS_LOG}

while true
do
    echo "[$(date)] Syncing ${BUILDALL_SYNCDIR}..." >> ${GETBUILDS_LOG}
    rsync -az --delete ${UNAME}@${BUILDMC}:${BUILDALL_SYNCDIR} ${WORKSPACE}/ >> ${GETBUILDS_LOG} 2>&1

    if [ -f ${BUILDALL_DONE} ]
    then
        echo -e "\n----------------------------------\n[$(date)] Found ${BUILDALL_DONE}" >> ${GETBUILDS_LOG}
        echo "[$(date)] Creating tarballs on buildmc..." >> ${GETBUILDS_LOG}

        echo "Generating tarballs..." >> ${GETBUILDS_LOG}
        ssh ${UNAME}@${BUILDMC} "cd ${WORKSPACE} && ./genTarballs.sh" >> ${GETBUILDS_LOG} 2>&1
        echo "Gzipping log files..." >> ${GETBUILDS_LOG}
        ssh ${UNAME}@${BUILDMC} "cd ${WORKSPACE} && gzip -f *.log" >> ${GETBUILDS_LOG} 2>&1
        echo "creating checksum file..." >> ${GETBUILDS_LOG}
        ssh ${UNAME}@${BUILDMC} "cd ${WORKSPACE} && sha256sum *.gz > ${CSUMSFILE}" >> ${GETBUILDS_LOG} 2>&1
        echo "---List of files in ${WORKSPACE}---------" >> ${GETBUILDS_LOG}
        ssh ${UNAME}@${BUILDMC} "cd ${WORKSPACE} && TZ=Asia/Kolkata ls -lhta" >> ${GETBUILDS_LOG} 2>&1
        echo "-----------------------------------------" >> ${GETBUILDS_LOG}

        echo -e "\n[$(date)] Downloading to local machine" >> ${GETBUILDS_LOG}
        scp ${UNAME}@${BUILDMC}:${WORKSPACE}/*.gz ${WORKSPACE}/ >> ${GETBUILDS_LOG} 2>&1
        scp ${UNAME}@${BUILDMC}:${WORKSPACE}/${CSUMSFILE} ${WORKSPACE}/ >> ${GETBUILDS_LOG} 2>&1
        cd ${WORKSPACE} && sha256sum -c ${CSUMSFILE} >> ${GETBUILDS_LOG} 2>&1

        echo -e "\n[$(date)] Extracting ${CORE_BUILD_TARBALL} ..." >> ${GETBUILDS_LOG}
        cd ${WORKSPACE}
        tar -xf ${CORE_BUILD_TARBALL} >> ${GETBUILDS_LOG} 2>&1
        echo "Done extracting for core" >> ${GETBUILDS_LOG}

        if [ "${COREONLY}" -eq "0" ]
        then
            echo -e "\n[$(date)] Extracting ${ONLINE_BUILD_TARBALL} ..." >> ${GETBUILDS_LOG}
            cd ${WORKSPACE}
            tar -xf ${ONLINE_BUILD_TARBALL} >> ${GETBUILDS_LOG} 2>&1
            echo "Done extracting for online" >> ${GETBUILDS_LOG}
        fi

        echo "Syncing file timestamps for core"  >> ${GETBUILDS_LOG}
        cd ${WORKSPACE} && rsync -vrt --size-only --existing --exclude '.git' ${UNAME}@${BUILDMC}:${COREDIR}/ ${COREDIR}/
        if [ "${COREONLY}" -eq "0" ]
        then
            echo "Syncing file timestamps for online"  >> ${GETBUILDS_LOG}
            cd ${WORKSPACE} && rsync -vrt --size-only --existing --exclude '.git' ${UNAME}@${BUILDMC}:${ONLINEDIR}/ ${ONLINEDIR}/
        fi

        echo "The builds have been setup in local-machine. Check with 'make build-nocheck' etc then remove buildmc." >> ${GETBUILDS_LOG}
        echo -e "\n[$(date)] Done all, exiting..." >> ${GETBUILDS_LOG}

        exit

    elif [ -f ${BUILDALL_FAILED} ]
    then
        echo -e "\n---------------------------------\n[$(date)] Found ${BUILDALL_FAILED}" >> ${GETBUILDS_LOG}
    fi

    sleep 1m
done
