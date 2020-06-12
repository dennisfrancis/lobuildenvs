#!/bin/bash

source ../envvars.sh

echo "reporefresh chrootbuildmc"
ssh root@chrootbuildmc "apt-get update"

[ $? -ne 0 ] && { echo "chrootbuildmc refresh-repo failed! Not proceeding."; exit -1; }


echo "setting up chrootbuildmc for building a chroot"
ssh root@chrootbuildmc "apt-get install -y rsync git && cd /root && rm -rf ${LOBUILDENVS_REPO_NAME} && git clone ${LOBUILDENVS_REPO_URL}"

[ $? -ne 0 ] && { echo "setting up chrootbuildmc failed! Not proceeding."; exit -1; }


BUILDSCRIPTSDIR="/root/${LOBUILDENVS_REPO_NAME}/chroot-scripts"

echo "building chroot and LO dev-env in chrootbuildmc"
ssh root@chrootbuildmc "cd \"${BUILDSCRIPTSDIR}\" && bash build-chroot-background.sh"

[ $? -ne 0 ] && { echo "chroot/LOdev-env build in chrootbuildmc failed! Not proceeding."; exit -1; }


echo "creating chroot tarball in chrootbuildmc"
ssh root@chrootbuildmc "cd \"${BUILDSCRIPTSDIR}\" && bash create-chroot-tarball.sh"

[ $? -ne 0 ] && { echo "chroot tarball generation in chrootbuildmc failed! Not proceeding."; exit -1; }


echo "Chroot tarball is ready in the remote machine."

