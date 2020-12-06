FROM gitpod/workspace-full-vnc

RUN echo deb http://archive.ubuntu.com/ubuntu focal main restricted > /etc/apt/sources.list \
    && echo deb-src http://archive.ubuntu.com/ubuntu focal multiverse restricted main universe >> /etc/apt/sources.list \
    && echo deb http://archive.ubuntu.com/ubuntu focal-updates main restricted >> /etc/apt/sources.list \
    && echo deb-src http://archive.ubuntu.com/ubuntu focal-updates multiverse restricted main universe >> /etc/apt/sources.list \
    && echo deb http://archive.ubuntu.com/ubuntu focal universe >> /etc/apt/sources.list \
    && echo deb http://archive.ubuntu.com/ubuntu focal-updates universe >> /etc/apt/sources.list \
    && echo deb http://archive.ubuntu.com/ubuntu focal multiverse >> /etc/apt/sources.list \
    && echo deb http://archive.ubuntu.com/ubuntu focal-updates multiverse >> /etc/apt/sources.list \
    && echo deb http://archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse >> /etc/apt/sources.list \
    && echo deb-src http://archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse >> /etc/apt/sources.list \
    && echo deb http://archive.ubuntu.com/ubuntu focal-security main restricted >> /etc/apt/sources.list \
    && echo deb-src http://archive.ubuntu.com/ubuntu focal-security multiverse restricted main universe >> /etc/apt/sources.list \
    && echo deb http://archive.ubuntu.com/ubuntu focal-security universe >> /etc/apt/sources.list \
    && echo deb http://archive.ubuntu.com/ubuntu focal-security multiverse >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get full-upgrade \
    && apt-get install -y binutils locales sudo vim procps bash-completion \
    && locale-gen en_US.UTF-8 \
    && apt-get install -y build-essential git ccache junit4 gstreamer1.0-libav libkrb5-dev nasm graphviz libpython3-dev valgrind libpoco-dev \
    && apt-get install -y libpng-dev libcap-dev python3-polib libpam0g-dev libgtk2.0-dev \
    && apt-get install -y clang libclang-dev llvm llvm-dev xvfb chromium-browser npm \
    && apt-get build-dep -y libreoffice \
    && pip install lxml \
    && pip install polib \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


