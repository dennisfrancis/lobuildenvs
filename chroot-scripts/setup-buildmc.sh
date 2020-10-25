#!/bin/bash


LOCKFILE=setup-buildmc.lock

source ./envvars.sh

[ "$(whoami)" != "root" ] && { echo "Need to be root to run this!"; exit -1; }

[ -f ${LOCKFILE} ] && { echo "tried to run setup-buildmc.sh when ${LOCKFILE} is present"; exit -1; }

touch ${LOCKFILE}

cat sources.list > /etc/apt/sources.list
apt-get update
#apt-get full-upgrade -y
apt-get install -y schroot debootstrap rsync util-linux git procps wget curl

# Setup schroot config
cat schroot.conf > /etc/schroot/schroot.conf
cat fstab > /etc/schroot/default/fstab

# Setup normal user
echo "Setting up user ${UNAME}"
useradd -l -u ${USERID} -G sudo -md ${UHOME} -s /bin/bash -p ${UNUSEDPASS} ${UNAME}
# passwordless sudo for users in the 'sudo' group
sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

echo "Copying keys to ${UNAME}'s home"
# Copy ssh allowed keys
cp -r /root/.ssh ${UHOME}/
chown -R ${UNAME} ${UHOME}/.ssh

# Setup workspace
echo "Setting up ${WORKSPACE}"
mkdir -p ${WORKSPACE}


## move the core.git externals tarballs to workspace.
mv -f /root/${CORE_EXTERNALS_TARBALL_FNAME}   ${WORKSPACE}/

chown -R ${UNAME} ${WORKSPACE}
chmod -R 755 ${WORKSPACE}


# Clone lobuildenvs repo to home dir
sudo -u ${UNAME} bash -c "cd ${WORKSPACE}; rm -rf ${LOBUILDENVS_REPO_NAME}; git clone \"${LOBUILDENVS_REPO_URL}\""


# setup chroot from tarball
echo "Extracting chroot tarball to ${CHRDIR}"
rm -rf ${CHRDIR}
tar -xf ${CHRTARBALL} --directory / || { echo "${CHRTARBALL} extraction to / failed !"; rm -f ${LOCKFILE}; exit -1; }

rm -f ${LOCKFILE}

