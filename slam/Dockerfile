#FROM tensorflow/tensorflow:1.12.0-gpu
#FROM osrf/ros:noetic-desktop-full
FROM nvidia/opengl:1.2-glvnd-devel-ubuntu20.04
LABEL org.opencontainers.image.authors="rzh@umich.edu,junzhewu@umich.edu"
LABEL description="SLAM environment for Cassie"
LABEL version="0.2"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8


RUN apt-get update && apt-get install -y --no-install-recommends \
        sudo \
        dialog \
        apt-utils \
        libeigen3-dev \
        git \
        mercurial \
        pkg-config \
        mesa-utils \
        libxau-dev \
        libxdmcp-dev \
        libxcb1-dev \
        libxext-dev \
        libx11-dev \ 
        git \
        tmux \
        wget \
        curl \
        cmake \
        vim \ 
        build-essential \
        unzip \
        autoconf \
        autogen \
        automake \
        libtool \
        mlocate \
        zlib1g-dev \
        libopenblas-dev \
        libflann-dev \
        libopencv-dev \
        libpcl-dev \
        libboost-all-dev \
        libsuitesparse-dev \
        libtbb-dev \
         libusb-1.0-0-dev \
         libgtest-dev \
         pkg-config \
         cmake-curses-gui \
         gdb \
         clang \
         emacs \
         libpcap-dev \
         gnupg2 \
         x11-xserver-utils \
         lsb-release && \
    apt clean  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update

RUN apt-get install -y --no-install-recommends ros-noetic-desktop-full

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,compute,utility,display

# install zsh
RUN git clone https://github.com/tccoin/easy-linux.git \
    && cd easy-linux \
    && ./zsh.sh \
    && touch /root/.z

# install gitstatus
# https://github.com/romkatv/gitstatus/releases/tag/v1.3.1
RUN mkdir -p /root/.cache/gitstatus \
    && wget https://github.com/romkatv/gitstatus/releases/download/v1.5.1/gitstatusd-linux-x86_64.tar.gz -O - \
    | tar -zx -C /root/.cache/gitstatus/

# install tilix
RUN apt-get install -y --no-install-recommends tilix

# install intel-mkl
RUN wget -O - https://raw.githubusercontent.com/eddelbuettel/mkl4deb/master/script.sh | bash \
&& ln /usr/lib/x86_64-linux-gnu/libboost_serialization.so.1.71.0 /usr/lib/libBoost::serialization.so \
&& ln /usr/lib/x86_64-linux-gnu/libboost_timer.so.1.71.0 /usr/lib/libBoost::timer.so \
&& ln /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.71.0 /usr/lib/libBoost::thread.so \
&& ln /usr/lib/x86_64-linux-gnu/libboost_chrono.so.1.71.0 /usr/lib/libBoost::chrono.so \
&& apt-get install -y --no-install-recommends libmkl-intel-lp64 libmkl-gnu-thread libmkl-core libmetis-dev \
&& ln -s /opt/intel/compilers_and_libraries_2018.2.199/linux/compiler/lib/intel64_lin/libiomp5.so /usr/lib/libiomp5.so