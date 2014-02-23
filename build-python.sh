#!/bin/bash

#Builds Python2 and Python3 for CentOS 5x

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
  echo "gcc ${GCC_VERSION} needs to be built/installed"
  exit 1
fi

#Directories to build the source
PYTHON2_TEMPDIR=/tmp/build-python-${PYTHON2_VERSION}
PYTHON3_TEMPDIR=/tmp/build-python3-${PYTHON3_VERSION}

#If not using the built gcc 4.8.2
#Advice to use gcc44 to get rid of _decimal library not building
#look at http://superuser.com/questions/646455/how-to-fix-decimal-module-compilation-error-when-installing-python-3-3-2-in-cen
#sudo yum install gcc44 gcc44-c++ libstdc++-devel
#export CC=/usr/bin/gcc44

#Set LD_LIBRARY_PATH to local lib directory
export LD_LIBRARY_PATH=${GCC_PREFIX}/lib

cleartemp() {
  rm -r -f ${PYTHON2_TEMPDIR}
  rm -r -f ${PYTHON3_TEMPDIR}
}

maketemp() {
  mkdir ${PYTHON2_TEMPDIR}
  mkdir ${PYTHON3_TEMPDIR}
}

build_dependencies() {
  #$1 = temp directory $2 = install path
  TEMPDIR=$1
  IPATH=$2

  SAVED_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${IPATH}/lib

  cd ${TEMPDIR}
  extract_gzip ${HOSTDIR}/${OPENSSL_FILE}
  extract_gzip ${HOSTDIR}/${ZLIB_FILE} 
  extract_gzip ${HOSTDIR}/${READLINE_FILE}
  extract_gzip ${HOSTDIR}/${BZIP_FILE}
  extract_gzip ${HOSTDIR}/${XZ_FILE}
  extract_gzip ${HOSTDIR}/${SQLITE_FILE}
  extract_gzip ${HOSTDIR}/${SETUPTOOLS_FILE}

  #Build OpenSSL
  cd ${TEMPDIR}
  cd openssl-${OPENSSL_VERSION}/
  ./config --prefix=$IPATH --shared
  make
  if [ $? -ne 0 ]; then
    echo "failed make"
    exit 1
  fi
  make install

  #Build zlib

  cd ${TEMPDIR}
  cd zlib-${ZLIB_VERSION}/
  ./configure --prefix=$IPATH
  make
  if [ $? -ne 0 ]; then
    echo "failed make"
    exit 1
  fi
  make install

  #Download and Build readline
  cd ${TEMPDIR} 
  cd readline-${READLINE_VERSION}/
  ./configure --prefix=$IPATH
  make
  if [ $? -ne 0 ]; then
    echo "failed make"
    exit 1
  fi
  make install

  #Download and Build bzip2
  cd ${TEMPDIR}
  cd bzip2-${BZIP_VERSION}/
  make -f Makefile-libbz2_so
  if [ $? -ne 0 ]; then
    echo "failed make"
    exit 1
  fi
  make install PREFIX=$IPATH

  #Download and Build xz
  cd ${TEMPDIR}
  cd xz-${XZ_VERSION}/
  ./configure --prefix=$IPATH
  make
  if [ $? -ne 0 ]; then
    echo "failed make"
    exit 1
  fi
  make install

  #Download and Build Sqlite
  cd ${TEMPDIR}
  cd sqlite-autoconf-${SQLITE_VERSION}/
  ./configure --prefix=$IPATH
  make
  if [ $? -ne 0 ]; then
    echo "failed make"
    exit 1
  fi
  make install

  #restore LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=${SAVED_LD_LIBRARY_PATH}
}

install_setuptools() {
  #$1 = tempdir, $2=path where python is installed
  #assumes that setuptools was extracted in tempdir
  TEMPDIR=$1
  IPATH=$2

  SAVED_PATH=${PATH}
  export PATH=${IPATH}/bin:${PATH} 
  #install setuptools, pip, virtualenv
  cd ${TEMPDIR}
  cd setuptools-${SETUPTOOLS_VERSION}
  python setup.py build
  python setup.py install
  easy_install pip
  pip install virtualenv
  export PATH=${SAVED_PATH}
}

build_python2() {
  #$1 = tempdir, $2=install prefix
  TEMPDIR=$1
  IPATH=$2

  SAVED_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${IPATH}/lib

  cd ${TEMPDIR}
  extract_gzip ${HOSTDIR}/${PYTHON2_FILE}
  cd Python-${PYTHON2_VERSION}
  
  ./configure --enable-shared --prefix=${IPATH}
  
  make
  if [ $? -ne 0 ]; then
    echo "failed make for build_python2"
    exit 1
  fi
  
  make install
  if [ $? -ne 0 ]; then
    echo "make install failed for build_python2"
    exit 1
  fi


  install_setuptools ${TEMPDIR} ${IPATH}

  #restore LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=${SAVED_LD_LIBRARY_PATH}
}

build_python3() {
  #$1 = tempdir, $2=install prefix
  TEMPDIR=$1
  IPATH=$2
  SAVED_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${IPATH}/lib
  
  cd ${TEMPDIR}
  extract_gzip ${HOSTDIR}/${PYTHON3_FILE}
  cd Python-${PYTHON3_VERSION}
  
  ./configure --enable-shared --prefix=${IPATH}
  
  make
  if [ $? -ne 0 ]; then
    echo "failed make for build_python3"
    exit 1
  fi
  
  make install
  if [ $? -ne 0 ]; then
    echo "make install failed for build_python3"
    exit 1
  fi
  
  #symbolic link python3 to python
  cd ${IPATH}/bin
  ln -s python3 python

  #install setuptools
  install_setuptools ${TEMPDIR} ${IPATH}
  
  #restore LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=${SAVED_LD_LIBRARY_PATH}
}

cleartemp
maketemp

cd ${HOSTDIR}

download ${OPENSSL_URL} ${OPENSSL_FILE}
download ${ZLIB_URL} ${ZLIB_FILE}
download ${READLINE_URL} ${READLINE_FILE}
download ${BZIP_URL} ${BZIP_FILE}
download ${XZ_URL} ${XZ_FILE}
download ${SQLITE_URL} ${SQLITE_FILE}
download ${PYTHON3_URL} ${PYTHON3_FILE}
download ${PYTHON2_URL} ${PYTHON2_FILE}
download ${SETUPTOOLS_URL} ${SETUPTOOLS_FILE}

#clear out any currently installed python
#installations of same version
rm -r -f ${PYTHON2_PREFIX}
rm -r -f ${PYTHON3_PREFIX}

#build dependencies for each python
build_dependencies ${PYTHON2_TEMPDIR} ${PYTHON2_PREFIX}
build_dependencies ${PYTHON3_TEMPDIR} ${PYTHON3_PREFIX}

#build python2
build_python2 ${PYTHON2_TEMPDIR} ${PYTHON2_PREFIX}

#build python3
build_python3 ${PYTHON3_TEMPDIR} ${PYTHON3_PREFIX}

echo ${HOSTDIR}
echo ${PYTHON2_PREFIX}
echo ${PYTHON3_PREFIX}
cp ${HOSTDIR}/activate-python ${PYTHON2_PREFIX}
cp ${HOSTDIR}/activate-python ${PYTHON3_PREFIX}

#package python2
package python-${PYTHON2_VERSION}
#package python3
package python-${PYTHON3_VERSION}
