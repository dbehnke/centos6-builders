centos5-builders
================

Build a more modern gcc, cmake, python, nginx on centos5

Why? CentOS uses an older glibc (2.5) and building on this platform allows to make portable binaries that are forward compatible.  This is especially valuable, if you are like me and stuck using enterprise linux, but would like to use some newer software.

Tested with CentOS 5.10 - but should work on Oracle Linux 5, Red Hat Enterprise 5 variants.

I'm assuming you are using Vagrant

Prequisite Instructions
=======================

Most of the build scripts use the custom GCC.  Build gcc first before running any of the other build-xxxx.sh scripts.

1.  Install Centos 5.10 - Install yourself, or use the packer and vagrant files

2.  Build GCC 4.8.2 (This step can take as long as 3 hours) - Do this before you go to bed or something :)

        cd /vagrant
        sudo ./build_gcc.sh

Building Software
=================

* Version Numbers and Download URLs may break over time, they are stored in global-config.sh or in the build scripts themselves.

* All software will install to /opt by default

Run any of the other build scripts (example with python)

    cd /vagrant
    sudo ./build-python.sh


        
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


