FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04
LABEL org.opencontainers.image.authors="rzh@umich.edu,junzhewu@umich.edu"
LABEL description="Container for CURLY Minimum Viable SLAM"
LABEL version="0.6"
ARG USER

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
    zsh \
    python3-dev \
    python3-pip \
    python3-tk \
    python3-matplotlib \
    valgrind \
    kcachegrind \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# install ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update \
    && apt-get install -y --no-install-recommends ros-noetic-desktop-full \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# use current user
RUN adduser --disabled-password --gecos '' $USER
RUN adduser $USER sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER $USER
WORKDIR /home/$USER/

# install zsh
COPY scripts/zsh zsh
RUN cd zsh && bash install_zsh.sh

# install gitstatus
RUN mkdir -p /home/$USER/.cache/gitstatus \
    && wget https://github.com/romkatv/gitstatus/releases/download/v1.5.4/gitstatusd-linux-x86_64.tar.gz -O - \
    | tar -zx -C /home/$USER/.cache/gitstatus/

# install slam libraries
RUN mkdir /home/$USER/slam_lib/
WORKDIR /home/$USER/slam_lib/

COPY scripts/debian_mkl.sh debian_mkl.sh
RUN sudo bash debian_mkl.sh

RUN git clone https://gitlab.com/libeigen/eigen.git eigen/ -b 3.3.9
RUN cd eigen/ \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && sudo make install -j6

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
    && sudo make install -j6

RUN git clone https://github.com/borglab/gtsam.git gtsam/  -b 4.1.1
RUN cd gtsam/ \
    && mkdir -p build \
    && cd build \
    && cmake .. -DGTSAM_USE_SYSTEM_EIGEN=TRUE \
    && sudo make install -j6

RUN git clone https://github.com/RossHartley/invariant-ekf.git invariant-ekf/ -b devel
RUN cd invariant-ekf/ \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && make -j6 \
    && sudo mkdir -p /usr/local/share/inekf/cmake \
    && sudo cp inekfConfig.cmake /usr/local/share/inekf/cmake

RUN git clone https://github.com/OctoMap/octomap.git octomap/
RUN cd octomap/ \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && sudo make install -j6

RUN git clone https://github.com/strasdat/Sophus.git  sophus/
RUN sudo apt-get install -y --no-install-recommends libfmt-dev \
    && cd sophus/ \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && sudo make install -j6

RUN git clone https://github.com/lcm-proj/lcm.git  lcm/
RUN cd lcm/ \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && sudo make install -j6

RUN git clone https://github.com/rmsalinas/fbow.git  fbow/
RUN cd fbow/ \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && sudo make install -j6

RUN git clone https://github.com/google/glog.git  glog/
RUN cd glog/ \
    && cmake -S . -B build -G "Unix Makefiles" \
    && cmake --build build \
    && cmake --build build --target test \
    && sudo cmake --build build --target install

RUN wget https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.6.0.zip \
    && unzip yaml-cpp-0.6.0.zip && rm yaml-cpp-0.6.0.zip \
    && mv yaml-cpp-yaml-cpp-0.6.0/ yaml-cpp-0.6.0/ 
RUN cd ./yaml-cpp-0.6.0/ \
    && env CFLAGS='-fPIC' CXXFLAGS='-fPIC' cmake -DCMAKE_BUILD_TYPE=Release -Bbuild \
    && cmake --build build -v

RUN wget https://github.com/ceres-solver/ceres-solver/archive/refs/tags/2.1.0.tar.gz \
    && export CC=gcc-9 &&  export CXX=g++-9 \
    && tar zxf 2.1.0.tar.gz && mkdir ceres-bin && cd ceres-bin\
    && cmake ../ceres-solver-2.1.0 -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF\
    && make -j8 && sudo make install

RUN pip3 install matplotlib --upgrade
