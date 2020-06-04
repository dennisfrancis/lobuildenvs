#!/bin/bash

[ "$#" -ne 2 ] && echo "USAGE $0 <REPODIR> <BASE-COMMIT-HASH>" && exit

COREROOT=$1
BASEHASH=$2

WORKSPACE="/workspace"
#WORKSPACE="/home/dennis/devel"

[ -d ${WORKSPACE}/${COREROOT} ] || { echo "Cannot access ${WORKSPACE}/${COREROOT} !!"; exit -1; }

ORIGDIR="$(pwd)"

cd ${WORKSPACE}

##[1]## Generate core.git build tarball

CORE_TARBALL="${COREROOT}-build.tar.gz"
BUILDSUBDIRS="${COREROOT}/instdir ${COREROOT}/workdir ${COREROOT}/external/tarballs ${COREROOT}/compilerplugins"
#BUILDSUBDIRS="${COREROOT}/instdir ${COREROOT}/workdir"

echo "Generating build tarball with ${BUILDSUBDIRS}"

tar -czf ${CORE_TARBALL} ${BUILDSUBDIRS}

echo "Done."

ls -lht ${CORE_TARBALL}

echo ""



##[2]##

CHANGEDFILES_TARBALL="${COREROOT}-chgd-files.tar.gz"
echo "Generating changed src files tarball"

cd $COREROOT
FLIST=$(git diff --name-only ${BASEHASH})
cd -

CHANGED_FILES=""
for fname in ${FLIST}
do
	CHANGED_FILES="${CHANGED_FILES} ${COREROOT}/${fname}"
done

tar -czf ${CHANGEDFILES_TARBALL} ${CHANGED_FILES}

echo "Done."
ls -lht ${CHANGEDFILES_TARBALL}

echo ""

cd "${ORIGDIR}"
