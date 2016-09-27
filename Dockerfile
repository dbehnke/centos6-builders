FROM centos:6
RUN yum -y install centos-release-scl && \
  yum -y install devtoolset-4-gcc-c++ && \
  yum -y install gzip bzip2 wget perl && \
  yum clean all && \
  rm -r -f /var/cache/yum/*
#ADD . /vagrant
#RUN cd /vagrant && scl enable devtoolset-4 ./build-nginx.sh && \
#  rm -r -f /tmp/build-nginx && \
#  rm -f *.gz *.bz2 *.tgz
#RUN cd /vagrant && scl enable devtoolset-4 ./build-python.sh && \
#  rm -r -f /tmp/build-python* && \
#  rm -f *.gz *.bz2 *.tgz
