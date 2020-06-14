#!/bin/bash

[ "$#" -ne 1 ] && echo "USAGE $0 <BASE-COMMIT-HASH>" && exit

source ../envvars.sh

BASEHASH=$1

[ -d ${COREDIR} ] || { echo "Cannot access ${COREDIR} !!"; exit -1; }

ORIGDIR="$(pwd)"

cd ${WORKSPACE}

##[1]## Generate core.git build tarball

echo "Generating build tarball with ${CORE_BUILDSUBDIRS}"

tar -czf ${CORE_BUILD_TARBALL} ${CORE_BUILDSUBDIRS}

echo "Done."

ls -lht ${CORE_BUILD_TARBALL}

echo ""



##[2]##

echo "Generating changed src files tarball"

cd $COREDIR
FLIST=$(git diff --name-only ${BASEHASH})
cd -

CHANGED_FILES=""
for fname in ${FLIST}
do
	CHANGED_FILES="${CHANGED_FILES} ${COREDIR}/${fname}"
done

tar -czf ${CORE_CHANGEDFILES_TARBALL} ${CHANGED_FILES}

echo "Done."
ls -lht ${CORE_CHANGEDFILES_TARBALL}

echo ""

cd "${ORIGDIR}"

