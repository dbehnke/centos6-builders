#!/bin/bash

#Builds Nginx for CentOS 5x

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

#Host Filesystem where downloads will be stored
HOSTDIR=/vagrant

NGINX_PREFIX=/opt/nginx

#Common Install Path - will also be used for prefix for the makefiles
IPATH=${NGINX_PREFIX}
#clear out and recreate install path
rm -r -f $IPATH

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
export LD_LIBRARY_PATH=$IPATH/lib:${GCC_PREFIX}/lib
export CPPFLAGS=-I${NGINX_PREFIX}/include
export LDFLAGS=-L${NGINX_PREFIX}/lib

#Download and Build OpenSSL
cd $HOSTDIR
OPENSSL_VERSION=1.0.1f
OPENSSL_FILE=openssl-${OPENSSL_VERSION}.tar.gz
OPENSSL_URL=https://www.openssl.org/source/${OPENSSL_FILE}
if [ ! -f ${OPENSSL_FILE} ]; then
    wget ${OPENSSL_URL}
    if [ $? -ne 0 ]; then
      echo "failed download"
      exit 1
    fi
fi
cd $TEMPDIR
tar xvfz ${HOSTDIR}/${OPENSSL_FILE}
#cd openssl-${OPENSSL_VERSION}/
#./config --prefix=$IPATH --shared
#make
#if [ $? -ne 0 ]; then
#  echo "failed make"
#  exit 1
#fi
#make install

#Download and Build zlib
cd $HOSTDIR
ZLIB_VERSION=1.2.8
ZLIB_FILE=zlib-${ZLIB_VERSION}.tar.gz
ZLIB_URL=http://zlib.net/${ZLIB_FILE}
if [ ! -f ${ZLIB_FILE} ]; then
    wget ${ZLIB_URL}
    if [ $? -ne 0 ]; then
      echo "failed download"
      exit 1
    fi
fi
cd ${TEMPDIR}
tar xvfz ${HOSTDIR}/${ZLIB_FILE} 
#cd zlib-${ZLIB_VERSION}/
#./configure --prefix=$IPATH
#make
#if [ $? -ne 0 ]; then
#  echo "failed make"
#  exit 1
#fi
#make install

#Download and Build readline
#cd $HOSTDIR
#READLINE_VERSION=6.2
#READLINE_FILE=readline-${READLINE_VERSION}.tar.gz
#READLINE_URL=http://ftp.gnu.org/gnu/readline/${READLINE_FILE}
#if [ ! -f ${READLINE_FILE} ]; then
#    wget ${READLINE_URL}
#    if [ $? -ne 0 ]; then
#      echo "failed download"
#      exit 1
#    fi
#fi
#cd ${TEMPDIR}
#tar xvfz ${HOSTDIR}/${READLINE_FILE} 
#cd readline-${READLINE_VERSION}/
#./configure --prefix=$IPATH
#make
#if [ $? -ne 0 ]; then
#  echo "failed make"
#  exit 1
#fi
#make install

#Download and Build bzip2
#cd $HOSTDIR
#BZIP_VERSION=1.0.6
#BZIP_FILE=bzip2-${BZIP_VERSION}.tar.gz
#BZIP_URL=http://www.bzip.org/${BZIP_VERSION}/${BZIP_FILE}
#if [ ! -f ${BZIP_FILE} ]; then
#    wget ${BZIP_URL}
#    if [ $? -ne 0 ]; then
#      echo "failed download"
#      exit 1
#    fi
#fi
#cd ${TEMPDIR}
#tar xvfz ${HOSTDIR}/${BZIP_FILE} 
#cd bzip2-${BZIP_VERSION}/
#make -f Makefile-libbz2_so
#if [ $? -ne 0 ]; then
#  echo "failed make"
#  exit 1
#fi
#make install PREFIX=$IPATH

#Download and Build xz
#cd $HOSTDIR
#XZ_VERSION=5.0.5
#XZ_FILE=xz-${XZ_VERSION}.tar.gz
#XZ_URL=http://tukaani.org/xz/${XZ_FILE}
#if [ ! -f ${XZ_FILE} ]; then
#    wget ${XZ_URL}
#    if [ $? -ne 0 ]; then
#      echo "failed download"
#      exit 1
#    fi
#fi
#cd ${TEMPDIR}
#tar xvfz ${HOSTDIR}/${XZ_FILE} 
#cd xz-${XZ_VERSION}/
#./configure --prefix=$IPATH
#make
#if [ $? -ne 0 ]; then
#  echo "failed make"
#  exit 1
#fi
#make install

#Download and Build pcre
cd $HOSTDIR
PCRE_VERSION=8.34
PCRE_FILE=pcre-${PCRE_VERSION}.tar.bz2
PCRE_URL=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${PCRE_FILE}
if [ ! -f ${PCRE_FILE} ]; then
    wget ${PCRE_URL}
    if [ $? -ne 0 ]; then
      echo "failed download"
      exit 1
    fi
fi
cd ${TEMPDIR}
tar xvfj ${HOSTDIR}/${PCRE_FILE} 
#cd pcre-${PCRE_VERSION}/
#./configure --prefix=$IPATH
#make
#if [ $? -ne 0 ]; then
#  echo "failed make"
#  exit 1
#fi
#make install

#Download and Build nginx

cd $HOSTDIR
NGINX_VERSION=1.4.4
NGINX_FILE=nginx-${NGINX_VERSION}.tar.gz
NGINX_URL=http://nginx.org/download/${NGINX_FILE}
if [ ! -f ${NGINX_FILE} ]; then
    wget ${NGINX_URL}
    if [ $? -ne 0 ]; then
      echo "failed download"
      exit 1
    fi
fi
cd ${TEMPDIR}
tar xvfz ${HOSTDIR}/${NGINX_FILE} 
cd nginx-${NGINX_VERSION}/
./configure --with-pcre=../pcre-${PCRE_VERSION} \
    --with-http_ssl_module \
    --with-openssl=../openssl-${OPENSSL_VERSION} \
    --with-zlib=../zlib-${ZLIB_VERSION} \
    --prefix=${IPATH}
make
if [ $? -ne 0 ]; then
  echo "failed make"
  exit 1
fi
make install


#cp ${HOSTDIR}/activate-python.sh /opt