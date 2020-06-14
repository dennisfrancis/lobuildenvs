#!/bin/bash

source ../envvars.sh

echo "reporefresh buildmc"
ssh root@buildmc "apt-get update"

[ $? -ne 0 ] && { echo "buildmc refresh-repo failed! Not proceeding."; exit -1; }


echo "setting up buildmc for building a chroot"
ssh root@buildmc "apt-get install -y rsync git && cd /root && rm -rf ${LOBUILDENVS_REPO_NAME} && git clone ${LOBUILDENVS_REPO_URL}"

[ $? -ne 0 ] && { echo "setting up buildmc failed! Not proceeding."; exit -1; }

ssh root@buildmc "test -d /root/.ssh && test -f /root/.ssh/${SSH_KEYNAME} && test -f /root/.ssh/${SSH_KEYNAME}.pub"
NEED_SSHKEYS=$?
if [ ${NEED_SSHKEYS} -ne 0 ]
then
	ssh root@buildmc "mkdir -p /root/.ssh && chmod 700 && rm -f /root/.ssh/${SSH_KEYNAME}*" && \
		scp ~/.ssh/${SSH_KEYNAME} root@buildmc:/root/.ssh/ && \
		ssh root@buildmc "chmod 644 /root/.ssh/${SSH_KEYNAME}.pub && chmod 600 /root/.ssh/${SSH_KEYNAME}"
fi

# Host alias for storemc in buildmc
ssh root@buildmc "cat /root/.ssh/config | grep storemc" > /dev/null || \
	grep -B 1 -A 3 'Host storemc' ~/.ssh/config  | ssh root@buildmc "tee -a /root/.ssh/config"

# Copy chroot tarball, core.git/online.git tarballs
ssh root@buildmc "scp ${SSH_NOHOSTCHECK_FLAGS} root@storemc:/root/*.* /root/" || \
	{ echo "copy from storemc failed!"; exit -1; }

ssh root@buildmc "cd /root && sha256sum -c ${CSUMSFILE}" || { echo "Checksums failed for tarballs copied from storemc !"; exit -1; }

BUILDSCRIPTSDIR="/root/${LOBUILDENVS_REPO_NAME}/chroot-scripts"

echo "setting up buildmc"
ssh root@buildmc "cd \"${BUILDSCRIPTSDIR}\" && bash setup-buildmc-background.sh"

[ $? -ne 0 ] && { echo "buildmc setup failed! Not proceeding."; exit -1; }

echo "Done setting up buildmc"
