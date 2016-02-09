#!/usr/bin/env bash

set -e -u
set -o pipefail

CMAKEOPTIONS=${CMAKEOPTIONS:-""}
BUILD_TYPE=${BUILD_TYPE:-Release}
COVERAGE=${COVERAGE:-false}
CXX=${CXX:-g++}

if [[ ${COVERAGE} == true ]]; then
    PYTHONUSERBASE=$(pwd)/mason_packages/.link pip install --user cpp-coveralls;
    # TODO - do we need to pass to `CMAKE_EXE_LINKER_FLAGS` instead of LDFLAGS?
    export LDFLAGS="--coverage"
    export CXXFLAGS="--coverage"
    if [[ $(uname -s) == 'Linux' ]]; then
        export PYTHONPATH=$(pwd)/mason_packages/.link/lib/python2.7/site-packages
    else
        export PYTHONPATH=$(pwd)/mason_packages/.link/lib/python/site-packages
    fi
fi

rm -rf build
mkdir -p build
cd build

# common build args
CMAKE_ARGS=""

# extra args for mason build to ensure deps inside ./mason_packages are used
# MASON_HOME is set by ./bootstrap.sh currently
if [[ ${MASON_HOME:-false} != false ]]; then
    CMAKE_ARGS="${CMAKE_ARGS} -DBoost_NO_SYSTEM_PATHS=ON "
    CMAKE_ARGS="${CMAKE_ARGS} -DTBB_INSTALL_DIR=${MASON_HOME} "
    CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_INCLUDE_PATH=${MASON_HOME}/include "
    CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_LIBRARY_PATH=${MASON_HOME}/lib "
    CMAKE_ARGS="${CMAKE_ARGS} -DOSMPBF_INCLUDE_DIR=${MASON_HOME}/include "
elif [[ -d /tmp/osrm-source-installed-deps/ ]]; then
    CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_INCLUDE_PATH=/tmp/osrm-source-installed-deps/include "
    CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_LIBRARY_PATH=/tmp/osrm-source-installed-deps/lib "
fi

cmake ../ -DCMAKE_CXX_COMPILER="${CXX}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} ${CMAKEOPTIONS} ${CMAKE_ARGS}

set +e +u