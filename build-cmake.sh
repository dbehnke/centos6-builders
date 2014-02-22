#!/bin/bash

#Builds MySQL for CentOS 5x

#make sure we running as root
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

GCC_VERSION=4.8.2
GCC_PREFIX=/opt/gcc-${GCC_VERSION}

export CC=${GCC_PREFIX}/bin/gcc
export CXX=${GCC_PREFIX}/bin/g++

# Make sure custom gcc was built
if [ ! -f ${CC} ]; then
  echo "gcc 4.8.2 needs to be built/installed"
  exit 1
fi

HOSTDIR=/vagrant
INSTPREFIX=/opt
TEMPDIR=/tmp

CMAKE_VERSION=2.8.12.2
CMAKE_FILE=cmake-2.8.12.2.tar.gz
CMAKE_URL=http://www.cmake.org/files/v2.8/${CMAKE_FILE}
CMAKE_INSTDIR=${INSTPREFIX}/cmake

cd $HOSTDIR
wget ${CMAKE_URL}
cd /tmp
rm -r -f cmake*
sudo rm -r -f /opt/cmake*
tar xvfz ${HOSTDIR}/${CMAKE_FILE}
cd cmake-${CMAKE_VERSION}
export LD_LIBRARY_PATH=${GCC_PREFIX}/lib64
./configure --prefix=/opt/cmake
gmake
make
sudo LD_LIBRARY_PATH=${LD_LIBRARY_PATH} make install
