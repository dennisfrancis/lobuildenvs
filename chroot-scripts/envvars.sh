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
LODEVSETUP_SCRIPT=${LODEVSETUP_DIR}/lodevsetup.sh


