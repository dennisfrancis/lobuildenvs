source ../envvars.sh

LOCAL_CHROOT_TARBALL_DIR=/media/data/chroot-tarballs
LOCAL_CHRTARBALL=${LOCAL_CHROOT_TARBALL_DIR}/${CHRNAME}.tar.gz

LOCAL_SOURCE_TARBALL_DIR=/media/data/source-tarballs

CORE_TARBALL=${LOCAL_SOURCE_TARBALL_DIR}/${CORE_TARBALL_FNAME}
ONLINE_TARBALL=${LOCAL_SOURCE_TARBALL_DIR}/${ONLINE_TARBALL_FNAME}

# schroot sessions
BUILD_SESSION_NAME=build
BUILD_SESSION=session:build

# build log files
CORE_BUILD_LOG=${WORKSPACE}/core-build.log
CORE_CHECK_LOG=${WORKSPACE}/core-check.log
ONLINE_BUILD_LOG=${WORKSPACE}/online-build.log
ONLINE_CHECK_LOG=${WORKSPACE}/online-check.log

# number of parallel jobs to use in building
NPARALLEL=4

# ./configure command for online
ONLINE_CONFIG_CMD="./configure CC=clang CXX=clang++ --prefix=/tmp/online-cache --enable-silent-rules --with-lokit-path=${COREDIR}/include --with-lo-path=${COREDIR}/instdir --enable-debug --enable-cypress --no-create --no-recursion"
