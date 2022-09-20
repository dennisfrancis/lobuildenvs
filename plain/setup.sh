#!/bin/bash


[ "$(whoami)" != "root" ] && { echo "This needs to be run as root !"; exit -1; }


source ./envvars.sh
export DEBIAN_FRONTEND=noninteractive

cat sources.list > /etc/apt/sources.list
apt-get update
apt-get full-upgrade -y -q

apt-get install -y -q binutils locales sudo vim procps bash-completion nano wget curl rsync
locale-gen en_US.UTF-8
apt-get install -y -q build-essential git ccache junit4 gstreamer1.0-libav libkrb5-dev nasm graphviz libpython3-dev valgrind libpoco-dev
apt-get install -y -q libpng-dev libcap-dev python3-polib libpam0g-dev libgtk2.0-dev
apt-get install -y -q clang libclang-dev llvm llvm-dev lld xvfb chromium-browser npm
apt-get build-dep -y -q libreoffice
apt install -y -q python3-pip
pip3 install lxml
pip3 install polib
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/*


echo "Setting up user ${UNAME}"
useradd -l -u ${USERID} -G sudo -md ${UHOME} -s /bin/bash -p ${UNUSEDPASS} ${UNAME}

# passwordless sudo for users in the 'sudo' group
sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

# Copy ssh allowed keys
cp -r /root/.ssh ${UHOME}/
chown -R ${UNAME} ${UHOME}/.ssh


# Setup workspace
echo "Setting up ${WORKSPACE}"
mkdir -p ${WORKSPACE}
cp -r ${SCRIPTDIR}/*.sh ${WORKSPACE}/
cp -r ${SCRIPTDIR}/autogen.input ${WORKSPACE}/

chown -R ${UNAME} ${WORKSPACE}
chmod -R 755 ${WORKSPACE}

