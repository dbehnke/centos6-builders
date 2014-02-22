#!/bin/bash

#Global Config

HOSTDIR=/vagrant
INSTPREFIX=/opt
TEMPDIR=/tmp

GCC_VERSION=4.8.2
GCC_PREFIX=/opt/gcc-${GCC_VERSION}

CMAKE_VERSION=2.8.12.2
CMAKE_FILE=cmake-2.8.12.2.tar.gz
CMAKE_URL=http://www.cmake.org/files/v2.8/${CMAKE_FILE}
CMAKE_INSTDIR=${INSTPREFIX}/cmake

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


