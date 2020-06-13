# user settings
UNAME=dennis
UHOME=/home/$UNAME
USERID=1000
UNUSEDPASS=dennis

# workspace dir in the host
#WORKSPACE="/workspace"
WORKSPACE="/home/dennis/devel"

# chroot system
DEBVERSION=buster
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

# core.git and online.git repodirs/tarballs
REPODIR=core
CORE_TARBALL_FNAME=${REPODIR}-src.tar.gz
COREDIR=${WORKSPACE}/${REPODIR}

ONLINEREPODIR=online
ONLINE_TARBALL_FNAME=${ONLINEREPODIR}-src.tar.gz
ONLINEDIR=${WORKSPACE}/${ONLINEREPODIR}

CORE_REMOTE="github"
CORE_BRANCH="feature/calc-coordinates"

ONLINE_REMOTE="github"
ONLINE_BRANCH="feature/calc-coordinates"

CSUMSFILE=checksums.txt

CORE_TARBALL="${COREDIR}-build.tar.gz"
BUILDSUBDIRS="${COREDIR}/instdir ${COREDIR}/workdir ${COREDIR}/external/tarballs"
CHANGEDFILES_TARBALL="${COREDIR}-chgd-files.tar.gz"

