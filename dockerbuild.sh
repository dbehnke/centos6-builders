#!/bin/bash

tstamp=`date +%Y%m%d-%H%M`

#clean the output directory if it exists or create it
cd /vagrant
rm -r -f output/*
mkdir output

#standard dbehnke build
export INSTPREFIX=/usr/local/dbehnke
scl enable devtoolset-4 ./build-python.sh && \
  cd output && tar cvfz dbehnke-python-linux-${tstamp}.tar.gz ${INSTPREFIX}

#mydesktop build
cd /vagrant
export INSTPREFIX=/usr/local/dbehnke
scl enable devtoolset-4 ./build-nginx.sh && \
scl enable devtoolset-4 ./build-python.sh && \
  cd output && tar cvfz mydesktop-python-linux-${tstamp}.tar.gz ${INSTPREFIX}
