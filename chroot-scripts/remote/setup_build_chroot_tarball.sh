#!/bin/bash

source ../envvars.sh

echo "updating buildmc"
ssh root@buildmc "apt-get update && apt-get full-upgrade -y && shutdown -r now"

[ $? -ne 0 ] && { echo "buildmc update/reboot failed! Not proceeding."; exit -1; }

echo "Waiting 10s for buildmc to reboot..."
sleep 10s


echo "setting up buildmc for building a chroot"
ssh root@buildmc "apt-get install rsync git && cd /root && git clone ${LOBUILDENVS_REPO_URL}"

[ $? -ne 0 ] && { echo "setting up buildmc failed! Not proceeding."; exit -1; }


SETUPDIR="/root/${LOBUILDENVS_REPO_NAME}/chroot-scripts"

echo "building chroot and LO dev-env in buildmc"
ssh root@buildmc "cd \"${SETUPDIR}\" && bash host-setup-background.sh"

[ $? -ne 0 ] && { echo "chroot/LOdev-env build in buildmc failed! Not proceeding."; exit -1; }


echo "creating chroot tarball in buildmc"
ssh root@buildmc "cd \"${SETUPDIR}\" && bash create-chroot-tarball.sh"

[ $? -ne 0 ] && { echo "chroot tarball generation in buildmc failed! Not proceeding."; exit -1; }


echo "Chroot tarball is ready in the remote machine."
