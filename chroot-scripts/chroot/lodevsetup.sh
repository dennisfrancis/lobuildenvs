#!/bin/bash


[ "$(whoami)" != "root" ] && { echo "This needs to be run as root !"; exit -1; }

ischroot || { echo "Not in chroot!"; exit -1; }

cat sources.list > /etc/apt/sources.list
apt-get update
apt-get full-upgrade -y
apt-get install -y binutils locales sudo vim procps bash-completion
locale-gen en_US.UTF-8
apt-get install -y git ccache junit4 gstreamer1.0-libav libkrb5-dev nasm graphviz libpython3-dev valgrind libpoco-dev
apt-get install -y libpng-dev libcap-dev python3-polib libpam0g-dev libgtk2.0-dev
apt-get install -y clang libclang-dev llvm
apt-get install -y chromium
apt-get build-dep -y libreoffice
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/*

sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

