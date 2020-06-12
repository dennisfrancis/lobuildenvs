#!/bin/bash

source ../envvars.sh

echo "updating chrootbuildmc"
ssh root@chrootbuildmc "apt-get update && apt-get full-upgrade -y && shutdown -r now"

[ $? -ne 0 ] && { echo "chrootbuildmc update/reboot failed! Not proceeding."; exit -1; }

echo "Waiting 10s for chrootbuildmc to reboot..."
sleep 10s


echo "setting up chrootbuildmc for building a chroot"
ssh root@chrootbuildmc "apt-get install rsync git && cd /root && git clone ${LOBUILDENVS_REPO_URL}"

[ $? -ne 0 ] && { echo "setting up chrootbuildmc failed! Not proceeding."; exit -1; }


SETUPDIR="/root/${LOBUILDENVS_REPO_NAME}/chroot-scripts"

echo "building chroot and LO dev-env in chrootbuildmc"
ssh root@chrootbuildmc "cd \"${SETUPDIR}\" && bash build-chroot-background.sh"

[ $? -ne 0 ] && { echo "chroot/LOdev-env build in chrootbuildmc failed! Not proceeding."; exit -1; }


echo "creating chroot tarball in chrootbuildmc"
ssh root@chrootbuildmc "cd \"${SETUPDIR}\" && bash create-chroot-tarball.sh"

[ $? -ne 0 ] && { echo "chroot tarball generation in chrootbuildmc failed! Not proceeding."; exit -1; }


echo "Chroot tarball is ready in the remote machine."

