FROM nvidia/cudagl:11.3.0-devel-ubuntu18.04
#FROM osrf/ros:melodic-desktop-full
ARG DEBIAN_FRONTEND=neoninteractive
ARG USER

# author
MAINTAINER Ray Zhang

LABEL version="1.3"
LABEL description="Docker file: for setting up CVO-GPU"

# optional, if the default user is not "root", you might need to switch to root here and at the end of the script to the original user again.
# e.g.
# USER root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \ 
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 

# remove deprecated nvidia key
RUN apt install -y wget && wget -qO - https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - \
    &&  apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub

RUN  apt update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    gcc-9 \
    g++-9 \
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
    qt5-default \
    libflann-dev \
    libopencv-dev \
    libpcl-dev \
    libboost-all-dev \
    libsuitesparse-dev \
    libatlas-base-dev \
    libtbb-dev \
    libusb-1.0-0-dev \
    libgtest-dev \
    libgoogle-glog-dev \
    pkg-config \
    software-properties-common \
    cmake-curses-gui \
    gdb 

######## Install Eigen 3.3.9
RUN  mkdir -p /home/root/tmp/ \
    &&   wget https://gitlab.com/libeigen/eigen/-/archive/3.3.9/eigen-3.3.9.tar.bz2 \
    &&   tar -xf eigen-3.3.9.tar.bz2  && rm eigen-3.3.9.tar.bz2 \
    &&   mv eigen-3.3.9 /home/root/tmp/eigen-3.3.9 \
    &&   cd /home/root/tmp/eigen-3.3.9 \
    &&   export CC=gcc-9 &&  export CXX=g++-9 \
    &&   mkdir build && cd build && cmake .. && make -j && make install

######## Install sophus
RUN  mkdir -p /home/root/tmp/ \
    &&   wget https://github.com/strasdat/Sophus/archive/v1.0.0.tar.gz \
    &&   tar -xf v1.0.0.tar.gz  \
    &&   mv Sophus-1.0.0 /home/root/tmp/Sophus-1.0.0 \
    &&   cd /home/root/tmp/Sophus-1.0.0 \
    &&   mkdir build && cd build && cmake .. && make -j && make install

########### Install gtsam
#RUN cd /home/root/tmp/ \
#&& git clone https://github.com/borglab/gtsam.git \
#&& cd gtsam \
#&& mkdir build && cd build && cmake .. && make -j4 && make install

########### Install ceres
RUN cd /home/root/tmp && export CC=gcc-9 && export CXX=g++-9 \
    && wget https://github.com/ceres-solver/ceres-solver/archive/refs/tags/2.1.0.tar.gz \
    &&   export CC=gcc-9 &&  export CXX=g++-9 \
    && tar zxf 2.1.0.tar.gz && mkdir ceres-bin && cd ceres-bin && cmake ../ceres-solver-2.1.0 \
    &&  make -j8 && make install

########### Install yaml-cpp 
RUN cd /home/root/tmp \
    && wget https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.7.0.zip \
    && unzip yaml-cpp-0.7.0.zip && rm yaml-cpp-0.7.0.zip \
    && mv yaml-cpp-yaml-cpp-0.7.0/ yaml-cpp-0.7.0/ 

COPY CMakeLists.txt.yaml-cpp /home/root/tmp/yaml-cpp-0.7.0/CMakeLists.txt

RUN cd /home/root/tmp/yaml-cpp-0.7.0/ && mkdir build && cd build && cmake .. && make -j8 && make install

########### Install pcl-1.9.1
#RUN cd /home/root/tmp/ && export CC=gcc-7 && export CXX=g++-7  \
#&& wget https://github.com/PointCloudLibrary/pcl/archive/pcl-1.9.1.tar.gz \
#&& tar -xf pcl-1.9.1.tar.gz && rm pcl-1.9.1.tar.gz \
#&& mv pcl-pcl-1.9.1 pcl-1.9.1  \
#&& mkdir -p pcl-1.9.1/build
#COPY  boost.h  /home/root/tmp/pcl-1.9.1/io/include/pcl/io/boost.h
#RUN cd /home/root/tmp/pcl-1.9.1/build  \
#&& cmake .. -DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_STANDARD_REQUIRED=ON && make -j8 && make install
#RUN rm -rf /home/root/tmp/*
########### Install pcl-1.9.1
RUN cd /home/root/tmp/ && export CC=gcc-9 && export CXX=g++-9  \
&& wget https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.12.1.tar.gz \
&& tar -xf pcl-1.12.1.tar.gz && rm pcl-1.12.1.tar.gz \
&& mv pcl-pcl-1.12.1 pcl-1.12.1  \
&& mkdir -p pcl-1.12.1/build && cd /home/root/tmp/pcl-1.12.1/build  \
&& cmake .. -DPCL_ENABLE_SSE=OFF -DPCL_ENABLE_AVX=OFF -DPCL_ENABLE_MARCHNATIVE=OFF -DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_STANDARD_REQUIRED=ON && make -j8 && make install
#&& wget https://github.com/PointCloudLibrary/pcl/archive/pcl-1.9.1.tar.gz \
#&& tar -xf pcl-1.9.1.tar.gz && rm pcl-1.9.1.tar.gz \
#&& mv pcl-pcl-1.9.1 pcl-1.9.1  \
#&& mkdir -p pcl-1.9.1/build
#COPY  boost.h  /home/root/tmp/pcl-1.9.1/io/include/pcl/io/boost.h
#RUN cd /home/root/tmp/pcl-1.9.1/build  \
#&&   export CC=gcc-9 &&  export CXX=g++-9 \
#&& cmake .. && make -j4 && make install

RUN rm -rf /home/root/tmp/*


#RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

#RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

#RUN apt-get update

#RUN apt-get install -y --no-install-recommends ros-melodic-desktop-full

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# emacs tools. Feel free to comment them out of you don't use emacs and llvm tools
RUN  apt update && \ 
     add-apt-repository ppa:kelleyk/emacs && \
     wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add - && \
     wget --no-check-certificate -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \ 
     add-apt-repository 'deb http://apt.llvm.org/bionic/   llvm-toolchain-bionic-10  main' && \
     apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'  && apt update &&\
     apt install -y emacs27 python3-pip clang-10 clangd-10 llvm-10 valgrind lldb-10 llvm-10-dev libllvm10 llvm-10-runtime bear mlocate global cmake && \
     apt clean  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN updatedb

ARG USER_ID
ARG GROUP_ID
RUN if  ! grep -q $GROUP_ID /etc/group ; then  groupadd --gid $GROUP_ID $USER; fi 
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID $USER
RUN adduser $USER sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
