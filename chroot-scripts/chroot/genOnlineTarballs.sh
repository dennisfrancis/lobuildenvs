#!/bin/bash

[ "$#" -ne 1 ] && echo "USAGE $0 <BASE-COMMIT-HASH>" && exit

source ../envvars.sh

BASEHASH=$1

[ -d ${ONLINEDIR} ] || { echo "Cannot access ${ONLINEDIR} !!"; exit -1; }

ORIGDIR="$(pwd)"

cd ${WORKSPACE}

##[1]## Generate online.git build tarball

echo "Generating build tarball with ${ONLINE_BUILDSUBDIRS}"

tar --exclude=${ONLINEREPODIR}/.git -czf ${ONLINE_BUILD_TARBALL} ${ONLINE_BUILDSUBDIRS}

echo "Done."

ls -lht ${ONLINE_BUILD_TARBALL}

echo ""



##[2]##

echo "Generating changed src files tarball"

cd ${ONLINEDIR}
FLIST=$(git diff --name-only ${BASEHASH})
cd -

CHANGED_FILES=""
for fname in ${FLIST}
do
	CHANGED_FILES="${CHANGED_FILES} ${ONLINEDIR}/${fname}"
done

tar -czf ${ONLINE_CHANGEDFILES_TARBALL} ${CHANGED_FILES}

echo "Done."
ls -lht ${ONLINE_CHANGEDFILES_TARBALL}

echo ""

cd "${ORIGDIR}"

