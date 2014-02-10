#!/bin/bash
GCC_VERSION=4.8.2
GCC_PREFIX=/opt/gcc-${GCC_VERSION}
PYTHON_PREFIX=/opt/python
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PYTHON_PREFIX}/lib
export PATH=${PYTHON_PREFIX}/bin:${PATH}
export CC=${GCC_PREFIX}/bin/gcc
