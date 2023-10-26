FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04
LABEL org.opencontainers.image.authors="junzhewu@umich.edu"
LABEL description="Container for Elastic Bridge (ROS wrapper for ElasticFusion)"
LABEL version="0.1"

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,compute,utility,display


ARG DEBIAN_FRONTEND=noninteractive

# install libraries and tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    dialog \
    apt-utils \
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
    lsb-release \
    tilix \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# install ROS
# RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# RUN apt-get update

# RUN apt-get install -y --no-install-recommends ros-noetic-desktop-full

# install zsh
RUN git clone https://github.com/tccoin/easy-linux.git /root/easy-linux \
    && cd /root/easy-linux \
    && bash zsh.sh \
    && touch /root/.z \
    && rm -r /root/easy-linux

# install gitstatus
# https://github.com/romkatv/gitstatus/releases/tag/v1.3.1
RUN mkdir -p /root/.cache/gitstatus \
    && wget https://github.com/romkatv/gitstatus/releases/download/v1.5.1/gitstatusd-linux-x86_64.tar.gz -O - \
    | tar -zx -C /root/.cache/gitstatus/

# install slam libraries

RUN sudo apt install libpcl-dev

RUN mkdir /root/elstic_ws/src -p
WORKDIR /root/elstic_ws/src

# Download libraries
RUN git clone https://github.com/RMonica/elastic_bridge.git \
    && git clone https://github.com/RMonica/init_fake_opengl_context.git \
    && git clone https://github.com/mp3guy/ElasticFusion.git elastic_bridge/deps/ElasticFusion

# Compile ElasticFusion Core module
## Update cmake
RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends software-properties-common \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add - \
    && sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' \
    && sudo apt-get install -y --no-install-recommends cmake

## Compile dependencies
RUN cd /root/elstic_ws/src/elastic_bridge/deps/ElasticFusion/ \
    && git submodule update --init \
    && cd third-party/Pangolin/ \
    && mkdir build \
    && cd build \
    && cmake .. -DEIGEN_INCLUDE_DIR=/root/elstic_ws/src/elastic_bridge/deps/ElasticFusion/third-party/Eigen/ -DBUILD_PANGOLIN_PYTHON=false \
    && make -j8


RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends cmake-qt-gui git build-essential libusb-1.0-0-dev libudev-dev openjdk-11-jdk freeglut3-dev libglew-dev libsuitesparse-dev zlib1g-dev libjpeg-dev \
    && cd /root/elstic_ws/src/elastic_bridge/deps/ElasticFusion/third-party/OpenNI2/ \
    && make -j8

## Install CUDA
# RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends cuda

## Compile elastic fusion
RUN cd /root/elstic_ws/src/elastic_bridge/deps/ElasticFusion/ \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j8

# Compile the package
# RUN cd /root/elstic_ws \
#     && . /opt/ros/noetic/setup.sh \
#     && catkin_make

# Apply the GUID patch
# COPY guid.patch /root/elstic_ws/src/elastic_bridge/patches/guid.patch
# RUN cd /root/elstic_ws/src/elastic_bridge/deps/ElasticFusion \
#     && patch -p1 -i ../../patches/guid.patch
