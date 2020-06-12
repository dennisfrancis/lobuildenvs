#!/bin/bash

LOCKFILE=buildchroot.lock

source ./envvars.sh

[ "$(whoami)" != "root" ] && { echo "Need to be root to run this!"; exit -1; }

[ -f ${LOCKFILE} ] && { echo "tried to run build-chroot.sh when ${LOCKFILE} is present"; exit -1; }

touch ${LOCKFILE}

cat sources.list > /etc/apt/sources.list
apt-get update
apt-get full-upgrade -y
apt-get install -y schroot debootstrap rsync util-linux git

# Setup schroot config
cat schroot.conf > /etc/schroot/schroot.conf
cat fstab > /etc/schroot/default/fstab

# Setup normal user

useradd -l -u ${USERID} -G sudo -md ${UHOME} -s /bin/bash -p ${UNUSEDPASS} ${UNAME}
# passwordless sudo for users in the 'sudo' group
sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

# Copy ssh allowed keys
cp -r /root/.ssh ${UHOME}/
chown -R ${UNAME} ${UHOME}/.ssh

# Setup workspace
mkdir -p ${WORKSPACE}
chown -R ${UNAME} ${WORKSPACE}
chmod -R 755 ${WORKSPACE}


# Clone lobuildenvs repo to home dir
sudo -u ${UNAME} bash -c "cd ${WORKSPACE}; rm -rf ${LOBUILDENVS_REPO_NAME}; git clone \"${LOBUILDENVS_REPO_URL}\""


# build a basic chroot if not present already.
[ -d ${CHRDIR}/bin ] && { echo "There is already a chroot setup at ${CHRDIR} !"; rm -f ${LOCKFILE}; exit 0; }

mkdir -p ${CHRDIR}

debootstrap --include=sudo ${DEBVERSION} ${CHRDIR} http://deb.debian.org/debian

# setup LibreOffice dev environment in the chroot
schroot -c "${CHRNAME}" bash ${LODEVSETUP_SCRIPT}

rm -f ${LOCKFILE}

