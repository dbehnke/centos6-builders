#!/bin/bash

tstamp=`date +%Y%m%d-%H%M`
image_name=buildenv-centos6-${tstamp}
run_name=build-${tstamp}

#build the container
docker build -t ${image_name} .

#build the image
docker run --name ${run_name} \
  -v $PWD:/vagrant ${image_name} /vagrant/dockerbuild.sh

#clean everything up
#docker rm ${run_name}
#docker rmi ${image_name}
