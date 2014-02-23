#!/bin/bash

#This doesn't compile mysql, it downloads the precompiled binary and installs
#it in home directory ($HOME/opt)

source `dirname $0`/global-config.sh

#root directory of where to install
INSTDIR=${HOME}/opt

#create directory
mkdir -p ${HOME}/opt

cd ${HOSTDIR}

MYSQL_VERSION=5.6.16
MYSQL_FILE=mysql-${MYSQL_VERSION}-linux-glibc2.5-x86_64.tar.gz
MYSQL_URL=http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-${MYSQL_VERSION}-linux-glibc2.5-x86_64.tar.gz
#download archive
download ${MYSQL_URL} ${MYSQL_FILE}
cd ${HOME}/opt

#remove the old directory
rm -r -f ${INSTDIR}/mysql-*
rm mysql

#extract the archive
extract_gzip ${HOSTDIR}/${MYSQL_FILE}

ln -s mysql-${MYSQL_VERSION}-linux-glibc2.5-x86_64 mysql
#ln -s mysqlmariadb-5.5.35-linux-x86_64 mariadb
