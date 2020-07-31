#!/bin/bash

source ../envvars.sh

[ ! -f ${LOCAL_CHRTARBALL} ] && { echo "Can't access ${LOCAL_CHRTARBALL} !"; exit -1; }

echo "Will upload the chroot tarball ${LOCAL_CHRTARBALL} ..."
echo ""

ORIGDIR=$(pwd)

cd ${WORKSPACE}

if [ -f ${CORE_EXTERNALS_TARBALL} ]
then
	echo "${CORE_EXTERNALS_TARBALL} already exists, not regenerating..."
else
	echo "Creating core.git externals tarball ${CORE_EXTERNALS_TARBALL_FNAME} from ${WORKSPACE}/${REPODIR}"
	tar -czf ${CORE_EXTERNALS_TARBALL} "${REPODIR}/.git" "${REPODIR}/external/tarballs"
fi

echo ""
ls -lht ${CORE_EXTERNALS_TARBALL}


ALLCSUMSFILE=${WORKSPACE}/${CSUMSFILE}
rm -f ${ALLCSUMSFILE}
touch ${ALLCSUMSFILE}

LOCAL_FILES="${CORE_EXTERNALS_TARBALL} ${LOCAL_CHRTARBALL}"
for fpath in ${LOCAL_FILES}
do
	cd $(dirname ${fpath})
	sha256sum $(basename ${fpath}) >> ${ALLCSUMSFILE}
done

cd ${ORIGDIR}

scp ${LOCAL_FILES} ${ALLCSUMSFILE} root@storemc:/root/
ssh root@storemc "cd /root/ && sha256sum -c ${CSUMSFILE}" || { echo "Checksum(s) failed for uploaded files !"; exit -1; }

echo "Uploads finished sucessfully."
