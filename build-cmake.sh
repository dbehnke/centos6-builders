#!/bin/bash

#Builds cmake for CentOS 5x

#make sure we running as root
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

source `dirname $0`/global-config.sh

# Make sure custom gcc was built
if [ ! -f ${CC} ]; then
  echo "gcc ${GCC_VERSION} needs to be built/installed"
  exit 1
fi

setcc

cd ${HOSTDIR}
download ${CMAKE_URL} ${CMAKE_FILE}

cd ${TEMPDIR}
rm -r -f cmake*
rm -r -f /opt/cmake*
extract_gzip ${HOSTDIR}/${CMAKE_FILE}
cd cmake-${CMAKE_VERSION}

export LD_LIBRARY_PATH=${GCC_PREFIX}/lib64
./configure --prefix=${CMAKE_PREFIX}
gmake
make
make install
package cmake-${CMAKE_VERSION}
