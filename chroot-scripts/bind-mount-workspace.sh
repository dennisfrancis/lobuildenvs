#!/bin/bash

source ./envvars.sh

[ "$(whoami)" != "root" ] && { echo "This needs to be run as root !"; exit -1; }


[ ! -d ${WORKSPACE} ] && { echo "Can't access the workspace dir: ${WORKSPACE} !"; exit -1; }
[ ! -d ${CHRDIR} ] && { echo "Can't access the chroot dir: ${CHRDIR} !"; exit -1; }


mkdir -p ${CHRWORKSPACE}

mountpoint -q ${CHRWORKSPACE} && { echo "The workspace is already mounted at ${CHRWORKSPACE}"; exit -1; }

mount --bind ${WORKSPACE} ${CHRWORKSPACE}

