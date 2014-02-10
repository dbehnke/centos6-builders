#!/bin/bash

#Builds Python2 and Python3 for CentOS 5x

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

PYTHON_PREFIX=/opt/python

#Common Install Path - will also be used for prefix for the makefiles
IPATH=${PYTHON_PREFIX}
#clear out and recreate install path
rm -r -f $IPATH

#Directory to build the source
TEMPDIR=/tmp/build-python

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
cd openssl-${OPENSSL_VERSION}/
./config --prefix=$IPATH --shared
make
if [ $? -ne 0 ]; then
  echo "failed make"
  exit 1
fi
make install

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
cd zlib-${ZLIB_VERSION}/
./configure --prefix=$IPATH
make
if [ $? -ne 0 ]; then
  echo "failed make"
  exit 1
fi
make install

#Download and Build readline
cd $HOSTDIR
READLINE_VERSION=6.2
READLINE_FILE=readline-${READLINE_VERSION}.tar.gz
READLINE_URL=http://ftp.gnu.org/gnu/readline/${READLINE_FILE}
if [ ! -f ${READLINE_FILE} ]; then
    wget ${READLINE_URL}
    if [ $? -ne 0 ]; then
      echo "failed download"
      exit 1
    fi
fi
cd ${TEMPDIR}
tar xvfz ${HOSTDIR}/${READLINE_FILE} 
cd readline-${READLINE_VERSION}/
./configure --prefix=$IPATH
make
if [ $? -ne 0 ]; then
  echo "failed make"
  exit 1
fi
make install

#Download and Build bzip2
cd $HOSTDIR
BZIP_VERSION=1.0.6
BZIP_FILE=bzip2-${BZIP_VERSION}.tar.gz
BZIP_URL=http://www.bzip.org/${BZIP_VERSION}/${BZIP_FILE}
if [ ! -f ${BZIP_FILE} ]; then
    wget ${BZIP_URL}
    if [ $? -ne 0 ]; then
      echo "failed download"
      exit 1
    fi
fi
cd ${TEMPDIR}
tar xvfz ${HOSTDIR}/${BZIP_FILE} 
cd bzip2-${BZIP_VERSION}/
make -f Makefile-libbz2_so
if [ $? -ne 0 ]; then
  echo "failed make"
  exit 1
fi
make install PREFIX=$IPATH

#Download and Build xz
cd $HOSTDIR
XZ_VERSION=5.0.5
XZ_FILE=xz-${XZ_VERSION}.tar.gz
XZ_URL=http://tukaani.org/xz/${XZ_FILE}
if [ ! -f ${XZ_FILE} ]; then
    wget ${XZ_URL}
    if [ $? -ne 0 ]; then
      echo "failed download"
      exit 1
    fi
fi
cd ${TEMPDIR}
tar xvfz ${HOSTDIR}/${XZ_FILE} 
cd xz-${XZ_VERSION}/
./configure --prefix=$IPATH
make
if [ $? -ne 0 ]; then
  echo "failed make"
  exit 1
fi
make install

#Download and Build Sqlite
cd $HOSTDIR
SQLITE_VERSION=3080300
SQLITE_FILE=sqlite-autoconf-${SQLITE_VERSION}.tar.gz
SQLITE_URL=https://sqlite.org/2014/${SQLITE_FILE}
if [ ! -f ${SQLITE_FILE} ]; then
    wget ${SQLITE_URL}
    if [ $? -ne 0 ]; then
      echo "failed download"
      exit 1
    fi
fi
cd ${TEMPDIR}
tar xvfz ${HOSTDIR}/${SQLITE_FILE}
cd sqlite-autoconf-${SQLITE_VERSION}/
./configure --prefix=$IPATH
make
if [ $? -ne 0 ]; then
  echo "failed make"
  exit 1
fi
make install

#Download and Build Python 3
cd ${HOSTDIR}
PYTHON3_VERSION=3.3.3
PYTHON3_FILE=Python-${PYTHON3_VERSION}.tgz
PYTHON3_URL=http://python.org/ftp/python/${PYTHON3_VERSION}/Python-${PYTHON3_VERSION}.tgz
if [ ! -f ${PYTHON3_FILE} ]; then
    wget ${PYTHON3_URL}
    if [ $? -ne 0 ]; then
      echo "failed download"
      exit 1
    fi
fi
cd ${TEMPDIR}
tar xvfz ${HOSTDIR}/${PYTHON3_FILE}
cd Python-${PYTHON3_VERSION}
./configure --enable-shared --prefix=${IPATH}
make
if [ $? -ne 0 ]; then
  echo "failed make"
  exit 1
fi
make install

#Download and Build Python 2
cd ${HOSTDIR}
PYTHON2_VERSION=2.7.6
PYTHON2_FILE=Python-${PYTHON2_VERSION}.tgz
PYTHON2_URL=http://python.org/ftp/python/${PYTHON2_VERSION}/${PYTHON2_FILE}
if [ ! -f ${PYTHON2_FILE} ]; then
    wget ${PYTHON2_URL}
    if [ $? -ne 0 ]; then
      echo "failed download"
      exit 1
    fi
fi
cd ${TEMPDIR}
tar xvfz ${HOSTDIR}/${PYTHON2_FILE}
cd Python-${PYTHON2_VERSION}
./configure --enable-shared --prefix=${IPATH}
make
if [ $? -ne 0 ]; then
  echo "failed make"
  exit 1
fi
make install

cp ${HOSTDIR}/activate-python.sh /opt