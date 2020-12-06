FROM gitpod/workspace-full-vnc

RUN sudo sh -c "echo deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted >> /etc/apt/sources.list" \
 && sudo sh -c "echo deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted >> /etc/apt/sources.list" \
 && sudo sh -c "echo deb-src http://security.ubuntu.com/ubuntu/ focal-security main restricted >> /etc/apt/sources.list" \
 && sudo sh -c "echo deb-src http://security.ubuntu.com/ubuntu/ focal-security universe >> /etc/apt/sources.list" \
 && sudo sh -c "echo deb-src http://security.ubuntu.com/ubuntu/ focal-security multiverse >> /etc/apt/sources.list" \
 && sudo apt-get update \
 && sudo apt-get install -y binutils locales sudo vim procps bash-completion \
 && sudo locale-gen en_US.UTF-8 \
 && sudo apt-get install -y build-essential git ccache junit4 gstreamer1.0-libav libkrb5-dev nasm graphviz libpython3-dev valgrind libpoco-dev \
 && sudo apt-get install -y libpng-dev libcap-dev python3-polib libpam0g-dev libgtk2.0-dev \
 && sudo apt-get install -y clang libclang-dev llvm llvm-dev xvfb chromium-browser npm \
 && sudo apt-get build-dep -y libreoffice \
 && pip install lxml \
 && pip install polib \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

