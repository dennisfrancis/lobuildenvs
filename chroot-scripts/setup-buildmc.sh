#!/bin/bash


LOCKFILE=setup-buildmc.lock

source ./envvars.sh

[ "$(whoami)" != "root" ] && { echo "Need to be root to run this!"; exit -1; }

[ -f ${LOCKFILE} ] && { echo "tried to run setup-buildmc.sh when ${LOCKFILE} is present"; exit -1; }

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
## move the source tarballs to workspace.
mv -f /root/${CORE_TARBALL_FNAME}   ${WORKSPACE}/
mv -f /root/${ONLINE_TARBALL_FNAME} ${WORKSPACE}/
ORIGDIR=$(pwd)
cd ${WORKSPACE}

tar -xf ${CORE_TARBALL_FNAME} && tar -xf ${ONLINE_TARBALL_FNAME} || \
	{ echo "Failed to extract ${CORE_TARBALL_FNAME} / ${ONLINE_TARBALL_FNAME}"; cd ${ORIGDIR}; exit -1; }

rm -f ${CORE_TARBALL_FNAME} ${ONLINE_TARBALL_FNAME}
cd ${REPODIR}       && git reset --hard ${CORE_BRANCH}   && git checkout ${CORE_BRANCH}   && cd ${WORKSPACE}
cd ${ONLINEREPODIR} && git reset --hard ${ONLINE_BRANCH} && git checkout ${ONLINE_BRANCH} && cd ${WORKSPACE}

cd ${ORIGDIR}
chown -R ${UNAME} ${WORKSPACE}
chmod -R 755 ${WORKSPACE}


# Clone lobuildenvs repo to home dir
sudo -u ${UNAME} bash -c "cd ${WORKSPACE}; rm -rf ${LOBUILDENVS_REPO_NAME}; git clone \"${LOBUILDENVS_REPO_URL}\""


# setup chroot from tarball
rm -rf ${CHRDIR}
tar -xf ${CHRTARBALL} --directory / || { echo "${CHRTARBALL} extraction to / failed !"; exit -1; }

