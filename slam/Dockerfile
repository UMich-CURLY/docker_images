FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04
LABEL org.opencontainers.image.authors="rzh@umich.edu,junzhewu@umich.edu"
LABEL description="Container for CURLY Minimum Viable SLAM"
LABEL version="0.3"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,compute,utility,display


# install libraries and  tools
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
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update

RUN apt-get install -y --no-install-recommends ros-noetic-desktop-full

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

RUN mkdir /root/slam_lib/

WORKDIR /root/slam_lib/

COPY scripts/debian_mkl.sh debian_mkl.sh

RUN bash debian_mkl.sh

RUN git clone https://gitlab.com/libeigen/eigen.git eigen/ -b 3.3.9
RUN cd eigen/ \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && make install -j16

RUN wget https://github.com/opencv/opencv/archive/4.5.5.zip -q -O opencv.zip \
    && unzip -q opencv.zip \
    && mv opencv-4.5.5 opencv \
    && rm opencv.zip \
    && cd opencv \
    && wget https://github.com/opencv/opencv_contrib/archive/4.5.5.zip -q -O opencv_contrib.zip \
    && unzip -q opencv_contrib.zip \
    && mv opencv_contrib-4.5.5 opencv_contrib \
    && rm opencv_contrib.zip
RUN cd opencv/ \
    && mkdir -p build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=RELEASE \
            -DCMAKE_INSTALL_PREFIX=/usr \
            -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
            -DOPENCV_ENABLE_NONFREE=ON .. \
    && make install -j16

RUN git clone https://github.com/borglab/gtsam.git gtsam/  -b 4.1.1
RUN cd gtsam/ \
    && mkdir -p build \
    && cd build \
    && cmake .. -DGTSAM_USE_SYSTEM_EIGEN=TRUE \
    && make install -j16

RUN git clone https://github.com/RossHartley/invariant-ekf.git invariant-ekf/ -b devel
RUN cd invariant-ekf/ \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && make -j16

RUN git clone https://github.com/OctoMap/octomap.git octomap/
RUN cd octomap/ \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && make install -j16

RUN git clone https://github.com/strasdat/Sophus.git  sophus/
RUN apt-get install -y --no-install-recommends libfmt-dev \
    && cd sophus/ \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && make install -j16
