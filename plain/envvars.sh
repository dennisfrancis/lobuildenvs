# ssh key names
SSH_KEYNAME=id_rsa_build

# user settings
UNAME=dennis
UHOME=/home/${UNAME}
USERID=1000
UNUSEDPASS=dennis
BUILDMC=buildmc
BUILDMCLOGIN=${UNAME}@${BUILDMC}

# workspace dir in the host
#WORKSPACE=/workspace
WORKSPACE=/home/dennis/devel

# chroot system
DEBVERSION=noble
CHRNAME=lodev-${DEBVERSION}
CHRDIR=/srv/chroot/${CHRNAME}
CHRWORKSPACE=${CHRDIR}/${WORKSPACE}

# chroot tarball
CHRTARBALL=/root/${CHRNAME}.tar.gz

# lobuildenvs repo
LOBUILDENVS_REPO_NAME=lobuildenvs
LOBUILDENVS_REPO_URL="https://github.com/dennisfrancis/${LOBUILDENVS_REPO_NAME}.git"

# LO dev setup script inside chroot
LODEVSETUP_DIR=${WORKSPACE}/${LOBUILDENVS_REPO_NAME}/chroot-scripts/chroot
LODEVSCRIPTS_DIR=${LODEVSETUP_DIR}
LODEVSETUP_SCRIPT=${LODEVSETUP_DIR}/lodevsetup.sh

## Build core only ----------------------------------------------
COREONLY=1

# core.git and online.git repodirs/tarballs
REPODIR=core
CORE_TARBALL_FNAME=${REPODIR}-src.tar.gz
CORE_EXTERNALS_TARBALL_FNAME=${REPODIR}-externals.tar.gz
COREDIR=${WORKSPACE}/${REPODIR}
COREURL="https://github.com/dennisfrancis/core.git"

ONLINEREPODIR=online
ONLINE_TARBALL_FNAME=${ONLINEREPODIR}-src.tar.gz
ONLINEDIR=${WORKSPACE}/${ONLINEREPODIR}
ONLINEURL="https://github.com/dennisfrancis/online.git"

CORE_BRANCH=private/dennisf/co-24.04
ONLINE_BRANCH=private/dennisf/typescript

CSUMSFILE=checksums.txt

# schroot sessions
BUILD_SESSION_NAME=build
BUILD_SESSION=session:build

# Build tarballs
CORE_BUILD_TARBALL=${COREDIR}-build.tar.gz
CORE_BUILDSUBDIRS="${REPODIR}/instdir ${REPODIR}/workdir ${REPODIR}/external"
CORE_CHANGEDFILES_TARBALL=${COREDIR}-chgd-files.tar.gz

ONLINE_BUILD_TARBALL=${ONLINEDIR}-build.tar.gz
ONLINE_BUILDSUBDIRS=${ONLINEREPODIR}
ONLINE_CHANGEDFILES_TARBALL=${ONLINEDIR}-chgd-files.tar.gz


# build log files
CORE_BUILD_LOG=${WORKSPACE}/core-build.log
CORE_CHECK_LOG=${WORKSPACE}/core-check.log
ONLINE_BUILD_LOG=${WORKSPACE}/online-build.log
ONLINE_CHECK_LOG=${WORKSPACE}/online-check.log


# ./configure command for online
ONLINE_CONFIG_CMD="./configure --prefix=/tmp/online-cache --enable-silent-rules --with-lokit-path=${COREDIR}/include --with-lo-path=${COREDIR}/instdir --enable-debug --enable-cypress --disable-ssl"


# make check targets
CORE_MAKECHECK_TARGETS="vcl.check sfx2.check svx.check editeng.check sc.check chart2.check desktop.check"
#CORE_MAKECHECK_TARGETS="sc.check desktop.check"
ONLINE_MAKECHECK_TARGETS="check"


# number of parallel jobs to use in building
NPARALLEL=4

# storemc vars
STOREMC_EXTRA_BLKDEV=/dev/sdc
STOREMC_EXTRA_MOUNT_DIR=/media/extra
STOREMC_BUILDTARBALLS_DIR=${STOREMC_EXTRA_MOUNT_DIR}/build

# SSH options
SSH_NOHOSTCHECK_FLAGS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# Local files
LOCAL_CHROOT_TARBALL_DIR=${WORKSPACE}/data/chroot-tarballs
LOCAL_CHRTARBALL=${LOCAL_CHROOT_TARBALL_DIR}/${CHRNAME}.tar.gz

LOCAL_SOURCE_TARBALL_DIR=${WORKSPACE}/data/source-tarballs
CORE_TARBALL=${LOCAL_SOURCE_TARBALL_DIR}/${CORE_TARBALL_FNAME}
ONLINE_TARBALL=${LOCAL_SOURCE_TARBALL_DIR}/${ONLINE_TARBALL_FNAME}
CORE_EXTERNALS_TARBALL=${LOCAL_SOURCE_TARBALL_DIR}/${CORE_EXTERNALS_TARBALL_FNAME}


BUILDALL_SYNCDIR=${WORKSPACE}/buildall.d
BUILDALL_LOG=${BUILDALL_SYNCDIR}/buildall.log
BUILDALL_DONE=${BUILDALL_SYNCDIR}/buildall.success
BUILDALL_FAILED=${BUILDALL_SYNCDIR}/buildall.failed
BUILDALL_RUNNING=${BUILDALL_SYNCDIR}/buildall.running

COMMITVARS_FILE=${WORKSPACE}/commitvars.sh
GETBUILDS_LOG=${WORKSPACE}/getbuilds.log

SCRIPTDIR=/root/plain
