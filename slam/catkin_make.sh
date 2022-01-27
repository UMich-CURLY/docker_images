# cd ~/ws/cassie_ros/ \
# && rm ./submodules/*/build/ -rf \
# && rm ./catkin_make/build/ -rf

cd ~/ws/cassie_ros/submodules/gtsam/ \
&& mkdir -p build \
&& cd build \
&& cmake .. -DGTSAM_USE_SYSTEM_EIGEN=TRUE -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF \
&& make install -j16

cd ~/ws/cassie_ros/submodules/invariant-ekf/ \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make -j16

cd ~/ws/cassie_ros/submodules/octomap/ \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make install -j16

# git clone 

cd ~/ws/cassie_ros/submodules/sophus/ \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make install -j16
apt install libfmt-dev

# frontend
apt remove libopencv*
# sudo apt install libpcl-dev ros-noetic-cv-bridge
cd ~/ws/cassie_ros/submodules/ \
&& wget https://github.com/opencv/opencv/archive/4.5.5.zip -O opencv.zip \
&& wget https://github.com/opencv/opencv_contrib/archive/4.5.5.zip -O opencv_contrib.zip \
&& unzip opencv.zip \
&& unzip opencv_contrib.zip -d opencv-4.5.5 \
&& rm opencv.zip \
&& rm opencv_contrib.zip \
&& mkdir opencv-4.5.5/build \
&& cd opencv-4.5.5/build \
&& cmake -DCMAKE_BUILD_TYPE=RELEASE \
         -DCMAKE_INSTALL_PREFIX=/usr \
         -DOPENCV_EXTRA_MODULES_PATH=~/ws/cassie_ros/submodules/opencv-4.5.5/opencv_contrib-4.5.5/modules \
         -DOPENCV_ENABLE_NONFREE=ON .. \
&& make install -j16


cd ~/ws/cassie_ros/catkin_ws \
&& catkin_make
