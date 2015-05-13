#!/bin/bash

#Global Config

HOSTDIR=/vagrant
INSTPREFIX=/opt
TEMPDIR=/tmp

#GCC
GCC_VERSION=4.9.2
GCC_PREFIX=/opt/gcc-${GCC_VERSION}
GLIBC_VERSION=`ldd --version | grep "ldd" | awk '{ print $4 }'`

#bzip
BZIP_VERSION=1.0.6
BZIP_FILE=bzip2-${BZIP_VERSION}.tar.gz
BZIP_URL=http://www.bzip.org/${BZIP_VERSION}/${BZIP_FILE}

#Cmake
CMAKE_VERSION=3.2.2
CMAKE_FILE=cmake-${CMAKE_VERSION}.tar.gz
CMAKE_URL=http://www.cmake.org/files/v3.2/${CMAKE_FILE}
CMAKE_PREFIX=${INSTPREFIX}/cmake-${CMAKE_VERSION}

#nginx
NGINX_VERSION=1.8.0
NGINX_FILE=nginx-${NGINX_VERSION}.tar.gz
NGINX_URL=http://nginx.org/download/${NGINX_FILE}
NGINX_PREFIX=${INSTPREFIX}/nginx-${NGINX_VERSION}

#OpenSSL
OPENSSL_VERSION=1.0.2a
OPENSSL_FILE=openssl-${OPENSSL_VERSION}.tar.gz
OPENSSL_URL=https://www.openssl.org/source/${OPENSSL_FILE}

#PCRE
PCRE_VERSION=8.37
PCRE_FILE=pcre-${PCRE_VERSION}.tar.bz2
PCRE_URL=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${PCRE_FILE}

#python 2
PYTHON2_VERSION=2.7.9
PYTHON2_FILE=Python-${PYTHON2_VERSION}.tgz
PYTHON2_URL=http://python.org/ftp/python/${PYTHON2_VERSION}/${PYTHON2_FILE}
PYTHON2_PREFIX=/opt/python-${PYTHON2_VERSION}

#python 3
PYTHON3_VERSION=3.4.3
PYTHON3_FILE=Python-${PYTHON3_VERSION}.tgz
PYTHON3_URL=http://python.org/ftp/python/${PYTHON3_VERSION}/Python-${PYTHON3_VERSION}.tgz
PYTHON3_PREFIX=/opt/python-${PYTHON3_VERSION}

#readline
READLINE_VERSION=6.3
READLINE_FILE=readline-${READLINE_VERSION}.tar.gz
READLINE_URL=http://ftp.gnu.org/gnu/readline/${READLINE_FILE}

#setuptools (for python)
SETUPTOOLS_VERSION=15.2
SETUPTOOLS_FILE=setuptools-${SETUPTOOLS_VERSION}.tar.gz
SETUPTOOLS_URL=https://pypi.python.org/packages/source/s/setuptools/${SETUPTOOLS_FILE}

#sqlite (for python)
SQLITE_VERSION=3081001
SQLITE_FILE=sqlite-autoconf-${SQLITE_VERSION}.tar.gz
SQLITE_URL=https://sqlite.org/2015/${SQLITE_FILE}

#lzma
XZ_VERSION=5.2.1
XZ_FILE=xz-${XZ_VERSION}.tar.gz
XZ_URL=http://tukaani.org/xz/${XZ_FILE}

#zlib
ZLIB_VERSION=1.2.8
ZLIB_FILE=zlib-${ZLIB_VERSION}.tar.gz
ZLIB_URL=http://zlib.net/${ZLIB_FILE}

setcc() {
  export CC=${GCC_PREFIX}/bin/gcc
  export CXX=${GCC_PREFIX}/bin/g++
}

download() {
  #parameters: $1 = url to download, $2 = filename
  cd ${HOSTDIR}
  URL=$1
  FILENAME=$2
  echo "Downloading ${FILENAME} from ${URL}..."
  if [ ! -f ${FILENAME} ]; then
    wget ${URL} --no-check-certificate
    if [ $? -ne 0 ]; then
      echo "failed download of ${URL}"
      exit 1
    fi
  fi
}

extract() {
  # $1 = extract params (i.e. xvfz), $2 = filename
  echo "Extracting ${2} using tar ${1}..."
  tar $1 $2
  if [ $? -ne 0 ]; then
    echo "failed extraction of ${2}"
    exit 1
  fi
}

extract_gzip() {
  # $1 = filename
  extract xfz $1
}

extract_bzip() {
  # $1 = filename
  extract xfj $1
}

package() {
  # $1 = Relative path where software is
  # e.g. python-3.3.4  for ${INSTPREFIX}/python-3.3.4
  PACKAGE_TIMESTAMP=`date +%Y%m%d`
  PACKAGE_ARCH=`uname -m`
  BINDIR=$1
  PACKAGE_ARCHIVE=${HOSTDIR}/${BINDIR}-gcc-${GCC_VERSION}-glibc-${GLIBC_VERSION}-${PACKAGE_ARCH}-${PACKAGE_TIMESTAMP}.tar.gz
  cd ${INSTPREFIX}
  echo Archiving ${INSTPREFIX}/${BINDIR} into ${PACKAGE_ARCHIVE}
  tar cfz ${PACKAGE_ARCHIVE} ${BINDIR}
}
