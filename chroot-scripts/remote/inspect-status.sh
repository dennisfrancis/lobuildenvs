#!/bin/bash

source ./localenv.sh

BUILDLOG=${WORKSPACE}/build.log
REPODIR=${REPODIR-core}
SCRIPTSDIR="${WORKSPACE}/${LOBUILDENVS_REPO_NAME}/chroot-scripts/chroot"

#ssh dennis@buildmc "tail /workspace/build.log && export REPODIR=cp64-optimized && /workspace/lobuildenvs/gitpod-scripts/printBuildInfo.sh"
ssh dennis@buildmc "tail ${BUILDLOG} && export REPODIR=${REPODIR} && ${SCRIPTSDIR}/printBuildInfo.sh"
echo "------[List of schroot sessions running]---------"
ssh dennis@buildmc "schroot -l --all-sessions"
echo "-------------------------------------------------"
