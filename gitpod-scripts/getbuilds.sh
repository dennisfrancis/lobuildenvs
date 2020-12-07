#!/bin/bash

source ./envvars.sh

[ $# -eq 1 ] || { echo "Usage $0 <address>" && exit -1; }

echo "Gzipping log files..."
cd ${WORKSPACE} && gzip -f *.log

echo "creating checksum file..." >> ${GETBUILDS_LOG}
cd ${WORKSPACE} && sha256sum *.gz > ${CSUMSFILE}"

echo "---List of files in ${WORKSPACE}---------"
cd ${WORKSPACE} && TZ=Asia/Kolkata ls -lhta

echo "Copying gzip files to $1"
scp ${WORKSPACE}/*.gz "$1":${WORKSPACE}/

echo "Copying checksum file"
scp ${WORKSPACE}/${CSUMSFILE} "$1":${WORKSPACE}/

echo "Checksum test"
ssh "$1" "cd ${WORKSPACE} && sha256sum -c ${CSUMSFILE}"

echo "Extracting tarballs"
ssh "$1" "cd ${WORKSPACE} && tar -xf ${CORE_BUILD_TARBALL} && tar -xf ${ONLINE_BUILD_TARBALL}"

echo "Syncing file timestamps (both core and online)"
cd ${WORKSPACE} && rsync -vrt --size-only --existing --exclude '.git' ${COREDIR}/ "$1":${COREDIR}/
cd ${WORKSPACE} && rsync -vrt --size-only --existing --exclude '.git' ${ONLINEDIR}/ "$1":${ONLINEDIR}/

echo "Done!"
