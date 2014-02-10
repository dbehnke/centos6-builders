centos5-gcc-python
==================

Build a more modern gcc and python on centos5

Currently builds GCC 4.8.2, Python 2.7.6 and Python 3.3.3 and installs them in /opt

Tested with CentOS 5.10 - but should work on Oracle Linux 5, Red Hat Enterprise 5 variants.

I'm assuming you are using Vagrant

Build Instructions
==================

1.  Install Centos 5.10 - Install yourself, or use the packer and vagrant files

2.  Build GCC 4.8.2 (This step can take as long as 3 hours) - Do this before you go to bed or something :)

        /vagrant/build_gcc.sh

3.  Build Python

        /vagrant/build_python.sh


