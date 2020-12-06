#!/bin/bash

test -f ../envvars.sh || { echo "Can't access ../envvars.sh" && exit -1; }

source ../envvars.sh

if [ -f ${COMMITVARS_FILE} ]
then
    source ${COMMITVARS_FILE}
else
    cd ${COREDIR}
    CORE_BASE_COMMIT=$(git rev-parse HEAD~1)
    cd ${ONLINEDIR}
    ONLINE_BASE_COMMIT=$(git rev-parse HEAD~1)
fi

rm -f ${GETBUILDS_LOG}

while true
do
    echo "[$(date)] Syncing ${BUILDALL_SYNCDIR}..." >> ${GETBUILDS_LOG}
    rsync -az --delete ${UNAME}@buildmc:${BUILDALL_SYNCDIR} ${WORKSPACE}/ >> ${GETBUILDS_LOG} 2>&1

    if [ -f ${BUILDALL_DONE} ]
    then
        echo -e "\n----------------------------------\n[$(date)] Found ${BUILDALL_DONE}" >> ${GETBUILDS_LOG}
        echo "[$(date)] Creating tarballs on buildmc..." >> ${GETBUILDS_LOG}

        echo "Generating core build tarballs..." >> ${GETBUILDS_LOG}
        ssh dennis@buildmc "cd ${LODEVSCRIPTS_DIR} && bash ./genCoreTarballs.sh ${CORE_BASE_COMMIT}" >> ${GETBUILDS_LOG} 2>&1
        echo "Generating online build tarballs..." >> ${GETBUILDS_LOG}
        ssh dennis@buildmc "cd ${LODEVSCRIPTS_DIR} && bash ./genOnlineTarballs.sh ${ONLINE_BASE_COMMIT}" >> ${GETBUILDS_LOG} 2>&1
        echo "Gzipping log files..." >> ${GETBUILDS_LOG}
        ssh dennis@buildmc "cd ${WORKSPACE} && gzip -f *.log" >> ${GETBUILDS_LOG} 2>&1
        echo "creating checksum file..." >> ${GETBUILDS_LOG}
        ssh dennis@buildmc "cd ${WORKSPACE} && sha256sum *.gz > ${CSUMSFILE}" >> ${GETBUILDS_LOG} 2>&1
        echo "---List of files in ${WORKSPACE}---------" >> ${GETBUILDS_LOG}
        ssh dennis@buildmc "cd ${WORKSPACE} && TZ=Asia/Kolkata ls -lhta" >> ${GETBUILDS_LOG} 2>&1
        echo "-----------------------------------------" >> ${GETBUILDS_LOG}

        echo -e "\n[$(date)] Downloading to local machine" >> ${GETBUILDS_LOG}
        scp dennis@buildmc:${WORKSPACE}/*.gz ${WORKSPACE}/ >> ${GETBUILDS_LOG} 2>&1
        scp dennis@buildmc:${WORKSPACE}/${CSUMSFILE} ${WORKSPACE}/ >> ${GETBUILDS_LOG} 2>&1
        cd ${WORKSPACE} && sha256sum -c ${CSUMSFILE} >> ${GETBUILDS_LOG} 2>&1

        echo -e "\n[$(date)] Extracting ${CORE_BUILD_TARBALL} and ${CORE_CHANGEDFILES_TARBALL} ..." >> ${GETBUILDS_LOG}
	    cd ${WORKSPACE}
        tar -xf ${CORE_BUILD_TARBALL} >> ${GETBUILDS_LOG} 2>&1
        tar -xf ${CORE_CHANGEDFILES_TARBALL} >> ${GETBUILDS_LOG} 2>&1
	    echo "Done extracting for core" >> ${GETBUILDS_LOG}

        echo -e "\n[$(date)] Extracting ${ONLINE_BUILD_TARBALL} and ${ONLINE_CHANGEDFILES_TARBALL} ..." >> ${GETBUILDS_LOG}
        cd ${WORKSPACE}
        tar -xf ${ONLINE_BUILD_TARBALL} >> ${GETBUILDS_LOG} 2>&1
        tar -xf ${ONLINE_CHANGEDFILES_TARBALL} >> ${GETBUILDS_LOG} 2>&1
        echo "Done extracting for online" >> ${GETBUILDS_LOG}

        echo "Core/Online builds have been setup in local-machine. Check with 'make build-nocheck' etc then remove buildmc." >> ${GETBUILDS_LOG}
        echo "\n[$(date)] Done all, exiting..." >> ${GETBUILDS_LOG}

        exit

    elif [ -f ${BUILDALL_FAILED} ]
    then
        echo -e "\n---------------------------------\n[$(date)] Found ${BUILDALL_FAILED}" >> ${GETBUILDS_LOG}
    fi

    sleep 1m
done
