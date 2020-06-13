#!/bin/bash

source ./localenv.sh

[ ! -f ${LOCAL_CHRTARBALL} ] && { echo "Can't access ${LOCAL_CHRTARBALL} !"; exit -1; }

echo "Will upload the chroot tarball ${LOCAL_CHRTARBALL} ..."

ORIGDIR=$(pwd)

cd ${WORKSPACE}

if [ -f ${CORE_TARBALL} ]
then
	echo "${CORE_TARBALL} already exists, not regenerating..."
else
	echo "Creating core.git source tarball ${CORE_TARBALL} from ${WORKSPACE}/${REPODIR}"
	tar -czf ${CORE_TARBALL} "${REPODIR}/.git" "${REPODIR}/external/tarballs"
fi

echo ""
ls -lht ${CORE_TARBALL}


if [ -f ${ONLINE_TARBALL} ]
then
	echo "${ONLINE_TARBALL} already exists, not regenerating..."
else
	echo "Creating online.git source tarball ${ONLINE_TARBALL} from ${WORKSPACE}/${ONLINEREPODIR}"
	tar -czf ${ONLINE_TARBALL} "${ONLINEREPODIR}/.git"
fi

echo ""
ls -lht ${ONLINE_TARBALL}
echo ""



ALLCSUMSFILE=${WORKSPACE}/${CSUMSFILE}
rm -f ${ALLCSUMSFILE}
touch ${ALLCSUMSFILE}

LOCAL_FILES="${CORE_TARBALL} ${ONLINE_TARBALL} ${LOCAL_CHRTARBALL}"
for fpath in ${LOCAL_FILES}
do
	cd $(dirname ${fpath})
	sha256sum $(basename ${fpath}) >> ${ALLCSUMSFILE}
done

cd ${ORIGDIR}

scp ${LOCAL_FILES} ${ALLCSUMSFILE} root@storemc:/root/
ssh root@storemc "cd /root/ && sha256sum -c ${CSUMSFILE}" || { echo "Checksum(s) failed for uploaded files !"; exit -1; }

echo "Uploads finished sucessfully."
