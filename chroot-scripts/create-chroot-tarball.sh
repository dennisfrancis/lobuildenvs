#!/bin/bash

source ./envvars.sh

[ ! -d ${CHRDIR} ] && { echo "Cannot access the chroot dir: ${CHRDIR} !"; exit -1; }

mountpoint -q ${CHRDIR}/proc && { echo "chroot session in ${CHRDIR} is active, exit it first"; exit -1; }

du -sh --exclude ${CHRWORKSPACE} ${CHRDIR}

echo ""
echo "Creating tarball ${CHRTARBALL} from ${CHRDIR}"
tar --exclude ${CHRWORKSPACE} -czf ${CHRTARBALL} ${CHRDIR}
echo "Done"

ls -lht ${CHRTARBALL}

