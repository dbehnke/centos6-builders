#!/bin/bash

#This doesn't compile mariadb, it downloads the precompiled binary and installs
#it in home directory ($HOME/opt)

source `dirname $0`/global-config.sh

#root directory of where to install
INSTDIR=${HOME}/opt

#create directory
mkdir -p ${HOME}/opt

cd ${HOSTDIR}

MARIADB_VERSION=5.5.35
MARIADB_FILE=mariadb-${MARIADB_VERSION}-linux-x86_64.tar.gz
MARIADB_URL=https://downloads.mariadb.org/f/mariadb-${MARIADB_VERSION}/kvm-bintar-centos5-amd64/${MARIADB_FILE}/from/http:/ftp.osuosl.org/pub/mariadb

#download archive
download ${MARIADB_URL} ${MARIADB_FILE}
cd ${HOME}/opt

#remove the old directory
rm -r -f ${INSTDIR}/mariadb-${MARIADB_VERSION}*
rm mariadb

#extract the archive
extract_gzip ${HOSTDIR}/${MARIADB_FILE}

ln -s mariadb-5.5.35-linux-x86_64 mariadb
