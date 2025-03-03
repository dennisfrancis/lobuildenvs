#!/bin/bash


[ "$(whoami)" != "root" ] && { echo "This needs to be run as root !"; exit -1; }


source ./envvars.sh
export DEBIAN_FRONTEND=noninteractive

#cat sources.list > /etc/apt/sources.list
apt-get update
apt-get full-upgrade -y -q

apt install -y -q binutils locales sudo vim procps bash-completion nano wget curl rsync
locale-gen en_US.UTF-8
apt install -y -q git build-essential zip ccache junit4 libkrb5-dev nasm graphviz \
    python3 python3-dev python3-setuptools qtbase5-dev libkf5coreaddons-dev \
    libkf5i18n-dev libkf5config-dev libkf5windowsystem-dev libkf5kio-dev \
    libqt5x11extras5-dev autoconf libcups2-dev libfontconfig1-dev gperf \
    openjdk-17-jdk doxygen libxslt1-dev xsltproc libxml2-utils libxrandr-dev \
    libx11-dev bison flex libgtk-3-dev libgstreamer-plugins-base1.0-dev \
    libgstreamer1.0-dev ant ant-optional libnss3-dev libavahi-client-dev \
    libxt-dev
apt install -y -q valgrind libpoco-dev dialog
apt install -y -q python3-polib libcap-dev \
    libpam-dev libzstd-dev wget git build-essential libtool \
    libcap2-bin python3-lxml libpng-dev libcppunit-dev \
    pkg-config fontconfig snapd chromium-browser npm
apt install -y -q python3-pip python3-venv
# pip3 install lxml
# pip3 install polib
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

sudo -u ${UNAME} ./setup_python.bash
