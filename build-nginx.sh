#!/bin/bash

#Builds Nginx for CentOS 5x

#make sure we running as root
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

source `dirname $0`/global-config.sh
setcc

# Make sure custom gcc was built
if [ ! -f ${CC} ]; then
  echo "gcc 4.8.2 needs to be built/installed"
  exit 1
fi

#clear out and recreate install path
rm -r -f ${NGINX_PREFIX}

#Directory to build the source
TEMPDIR=/tmp/build-nginx

#clear out and recreate temp directory
rm -r -f $TEMPDIR
mkdir $TEMPDIR

#If not using the built gcc 4.8.2
#Advice to use gcc44 to get rid of _decimal library not building
#look at http://superuser.com/questions/646455/how-to-fix-decimal-module-compilation-error-when-installing-python-3-3-2-in-cen
#sudo yum install gcc44 gcc44-c++ libstdc++-devel
#export CC=/usr/bin/gcc44

#Set LD_LIBRARY_PATH to local lib directory
export LD_LIBRARY_PATH=${NGINX_PREFIX}/lib:${GCC_PREFIX}/lib
export CPPFLAGS=-I${NGINX_PREFIX}/include
export LDFLAGS=-L${NGINX_PREFIX}/lib

cd ${HOSTDIR}

download ${OPENSSL_URL} ${OPENSSL_FILE}
download ${PCRE_URL} ${PCRE_FILE}
download ${ZLIB_URL} ${ZLIB_FILE}
download ${NGINX_URL} ${NGINX_FILE}

cd ${TEMPDIR}

extract_gzip ${HOSTDIR}/${OPENSSL_FILE}
extract_gzip ${HOSTDIR}/${ZLIB_FILE}
extract_bzip ${HOSTDIR}/${PCRE_FILE}
extract_gzip ${HOSTDIR}/${NGINX_FILE}

#Build nginx

cd ${TEMPDIR}/nginx-${NGINX_VERSION}
./configure --with-pcre=../pcre-${PCRE_VERSION} \
    --with-http_ssl_module \
    --with-openssl=../openssl-${OPENSSL_VERSION} \
    --with-zlib=../zlib-${ZLIB_VERSION} \
    --prefix=${NGINX_PREFIX}
make
if [ $? -ne 0 ]; then
  echo "failed make"
  exit 1
fi
make install
package nginx-${NGINX_VERSION}
