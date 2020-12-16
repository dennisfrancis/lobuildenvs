#!/bin/bash

source ./envvars.sh


[ -d ${COREDIR} ] || { echo "Cannot access ${COREDIR} !!"; exit -1; }
[ -d ${ONLINEDIR} ] || { echo "Cannot access ${ONLINEDIR} !!"; exit -1; }

ORIGDIR="$(pwd)"

cd ${WORKSPACE}



##[1]## Generate core.git build tarball

echo "Generating build tarball with ${CORE_BUILDSUBDIRS}"

tar -czf ${CORE_BUILD_TARBALL} ${CORE_BUILDSUBDIRS}

echo "Done."

ls -lht ${CORE_BUILD_TARBALL}

echo ""



##[2]## Generate online.git build tarball

echo "Generating build tarball with ${ONLINE_BUILDSUBDIRS}"

tar --exclude=${ONLINEREPODIR}/.git -czf ${ONLINE_BUILD_TARBALL} ${ONLINE_BUILDSUBDIRS}

echo "Done."

ls -lht ${ONLINE_BUILD_TARBALL}

echo ""



cd "${ORIGDIR}"
