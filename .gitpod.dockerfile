FROM amd64/debian:buster

RUN echo deb http://deb.debian.org/debian buster main contrib non-free > /etc/apt/sources.list \
    && echo deb-src http://deb.debian.org/debian buster main contrib non-free >> /etc/apt/sources.list \
    && echo deb http://deb.debian.org/debian buster-updates main contrib non-free >> /etc/apt/sources.list \
    && echo deb-src http://deb.debian.org/debian buster-updates main contrib non-free >> /etc/apt/sources.list \
    && echo deb http://security.debian.org/debian-security/ buster/updates main contrib non-free >> /etc/apt/sources.list \
    && echo deb-src http://security.debian.org/debian-security/ buster/updates main contrib non-free >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get full-upgrade \
    && apt-get install -y binutils locales sudo vim procps bash-completion \
    && locale-gen en_US.UTF-8 \
    && apt-get install -y git ccache junit4 gstreamer1.0-libav libkrb5-dev nasm graphviz libpython3-dev valgrind libpoco-dev \
    && apt-get install -y libpng-dev libcap-dev python3-polib libpam0g-dev libgtk2.0-dev \
    && apt-get install -y clang libclang-dev llvm \
    && apt-get build-dep -y libreoffice \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/gitpod
WORKDIR $HOME
# custom Bash prompt
RUN { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> .bashrc

