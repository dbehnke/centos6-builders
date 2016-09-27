centos6-builders
================

Build a more modern python, nginx on centos6

Why? CentOS uses an older glibc (2.12) and building on this platform allows to make portable binaries that are forward compatible.  This is especially valuable, if you are like me and stuck using enterprise linux, but would like to use some newer software.

Tested with CentOS 6.8 (via docker + software collections 2.2) - but should work on Oracle Linux 6, Red Hat Enterprise 6 variants.

I'm assuming you are using Docker

Prequisite Instructions
=======================

You'll need Docker or a Centos 6 VM / System.   I use Centos 6 because it already has packages available to easily install the Software Collections and Devtoolset 4.

If using docker you will want to mount the project directory to the container using the -v command line option.

I use /vagrant as the mountpoint out of habit from the days I used to use Vagrant more.

Docker:  docker build -t centos6-scl22 .

or Centos6:

        yum -y install centos-release-scl && \
        yum -y install devtoolset-4-gcc-c++ && \
        yum -y install gzip bzip2 perl

Building Software
=================

You'll need to enable the devtoolset-4 to have access to gcc and such.

* Version Numbers and Download URLs may break over time, they are stored in global-config.sh or in the build scripts themselves.

* All software will install to /opt by default

Run any of the other build scripts (example with python)

    cd /vagrant
    sudo scl enable devtoolset-4 ./build-python.sh



Activating Python Environment
=============================

Activate

    source /opt/activate_python.sh

Test Python 3

    [vagrant@localhost ~]$ python3
    Python 3.3.3 (default, Feb 10 2014, 02:11:48)
    [GCC 4.8.2] on linux
    Type "help", "copyright", "credits" or "license" for more information.
    >>>

Test Python 2

    [vagrant@localhost ~]$ python2
    Python 2.7.6 (default, Feb 10 2014, 02:15:21)
    [GCC 4.8.2] on linux2
    Type "help", "copyright", "credits" or "license" for more information.
    >>>
