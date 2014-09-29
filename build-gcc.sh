#!/bin/bash

#Builds a modern gcc on CentOS 5x
#credit to http://linux-problem-solver.blogspot.com/2013/12/installation-of-gcc-482-compilers-on.html
#for basis of this script.

#make sure we running as root
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

#Host Filesystem where downloads will be stored
HOSTDIR=/vagrant

#Define File Versions and Download URLs
GCC_VERSION=4.8.3
GCC_FILENAME=gcc-${GCC_VERSION}.tar.bz2
GCC_URL=http://www.netgull.com/gcc/releases/gcc-${GCC_VERSION}/${GCC_FILENAME}
#GCC_URL=http://mirrors.ispros.com.bd/gnu/gcc/gcc-${GCC_VERSION}/${GCC_FILENAME}

MPC_VERSION=1.0.2
MPC_FILENAME=mpc-${MPC_VERSION}.tar.gz
MPC_URL=http://www.multiprecision.org/mpc/download/${MPC_FILENAME}

MPFR_VERSION=3.1.2
MPFR_FILENAME=mpfr-${MPFR_VERSION}.tar.bz2
MPFR_URL=http://www.mpfr.org/mpfr-current/${MPFR_FILENAME}

GMP_VERSION=6.0.0a
GMP_FILENAME=gmp-${GMP_VERSION}.tar.bz2
GMP_URL=https://gmplib.org/download/gmp/${GMP_FILENAME}

ISL_VERSION=0.12.2
ISL_FILENAME=isl-${ISL_VERSION}.tar.bz2
ISL_URL=ftp://ftp.irisa.fr/pub/mirrors/gcc.gnu.org/gcc/infrastructure/${ISL_FILENAME}

CLOOG_VERSION=0.18.1
CLOOG_FILENAME=cloog-${CLOOG_VERSION}.tar.gz
CLOOG_URL=ftp://ftp.irisa.fr/pub/mirrors/gcc.gnu.org/gcc/infrastructure/${CLOOG_FILENAME}


#Common Install Path - will also be used for prefix for the makefiles
IPATH=/opt/gcc-${GCC_VERSION}
#clear out and recreate install path
rm -r -f $IPATH

#Directory to build the source
TEMPDIR=/tmp/buildgcc

#clear out and recreate temp directory
rm -r -f $TEMPDIR
mkdir $TEMPDIR

#prerequisites
##yum -y groupinstall "Development tools"

#32 bit library support
#centos 6 - yum -y install glibc-devel.i686 glibc-i686
##yum -y install glibc-devel.i386 glibc.i686

download() {
  #parameters: $1 = url to download, $2 = filename
  cd ${HOSTDIR}
  URL=$1
  FILENAME=$2
  echo "Downloading ${FILENAME} from ${URL}..."
  if [ ! -f ${FILENAME} ]; then
    wget ${URL}
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

#Download gcc and other prerequisites
cd ${HOSTDIR}
download ${GCC_URL} ${GCC_FILENAME}
download ${MPC_URL} ${MPC_FILENAME}
download ${MPFR_URL} ${MPFR_FILENAME}
download ${GMP_URL} ${GMP_FILENAME}
download ${ISL_URL} ${ISL_FILENAME}
download ${CLOOG_URL} ${CLOOG_FILENAME}

#extract gcc sources
cd ${TEMPDIR}
extract_bzip ${HOSTDIR}/${GCC_FILENAME}
GCC_SRC_ROOT=${TEMPDIR}/gcc-${GCC_VERSION}

#change to the gcc root and extract the rest
cd ${GCC_SRC_ROOT}
pwd

extract_gzip ${HOSTDIR}/${MPC_FILENAME}
extract_bzip ${HOSTDIR}/${MPFR_FILENAME}
extract_bzip ${HOSTDIR}/${GMP_FILENAME}
extract_bzip ${HOSTDIR}/${ISL_FILENAME}
extract_gzip ${HOSTDIR}/${CLOOG_FILENAME}

#rename dir without the version
mv mpc-${MPC_VERSION} mpc
mv mpfr-${MPFR_VERSION} mpfr
mv gmp-${GMP_VERSION} gmp
mv isl-${ISL_VERSION} isl
mv cloog-${CLOOG_VERSION} cloog

#configure gcc
pwd
./configure --prefix=${IPATH}
make
if [ $? -ne 0 ]; then
  echo "failed make"
  exit 1
fi
make -k check
make install

