#!/bin/bash
##
## cf https://software.intel.com/en-us/articles/installing-intel-free-libs-and-python-apt-repo

cd /tmp
wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB


## all products:
#sudo wget https://apt.repos.intel.com/setup/intelproducts.list -O /etc/apt/sources.list.d/intelproducts.list
## just MKL
sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'
## other (TBB, DAAL, MPI, ...) listed on page

apt-get update
apt-get install -y --no-install-recommends intel-mkl-64bit-2018.2-046   ## wants 500+mb :-/  installs to 1.8 gb :-/

## update alternatives
# update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so     libblas.so-x86_64-linux-gnu      /opt/intel/mkl/lib/intel64/libmkl_rt.so 150
# update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so.3   libblas.so.3-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 150
# update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so   liblapack.so-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 150
# update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so.3 liblapack.so.3-x86_64-linux-gnu  /opt/intel/mkl/lib/intel64/libmkl_rt.so 150

echo "/opt/intel/lib/intel64"     >  /etc/ld.so.conf.d/mkl.conf
echo "/opt/intel/mkl/lib/intel64" >> /etc/ld.so.conf.d/mkl.conf
ldconfig

echo "MKL_THREADING_LAYER=GNU" >> /etc/environment

ln /usr/lib/x86_64-linux-gnu/libboost_serialization.so.1.71.0 /usr/lib/libBoost::serialization.so
ln /usr/lib/x86_64-linux-gnu/libboost_timer.so.1.71.0 /usr/lib/libBoost::timer.so
ln /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.71.0 /usr/lib/libBoost::thread.so
ln /usr/lib/x86_64-linux-gnu/libboost_chrono.so.1.71.0 /usr/lib/libBoost::chrono.so
apt-get install -y --no-install-recommends libmkl-intel-lp64 libmkl-gnu-thread libmkl-core libmetis-dev
ln -s /opt/intel/compilers_and_libraries_2018.2.199/linux/compiler/lib/intel64_lin/libiomp5.so /usr/lib/libiomp5.so
