#!/bin/bash

source ./envvars.sh

ssh root@buildmc "mkdir -p ${SCRIPTDIR}"
scp *.sh sources.list ${COREDIR}/autogen.input root@buildmc:${SCRIPTDIR}

echo "Copy finished!"

