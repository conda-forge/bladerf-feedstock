#!/usr/bin/env bash

set -ex

mkdir build
cd build

cmake_config_args=(
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_LIBDIR=lib
    -DCMAKE_INSTALL_PREFIX=$PREFIX
    -DBLADERF_GROUP=plugdev
    -DBUILD_DOCUMENTATION=OFF
    -DENABLE_BACKEND_LIBUSB=ON
    -DENABLE_BACKEND_CYAPI=OFF
    -DENABLE_BACKEND_DUMMY=OFF
    -DENABLE_FX3_BUILD=OFF
    -DENABLE_HOST_BUILD=ON
    -DENABLE_LIBTECLA=OFF
    -DINSTALL_UDEV_RULES=ON
    -DTAGGED_RELEASE=ON
    -DTEST_LIBBLADERF=OFF
    -DTREAT_WARNINGS_AS_ERRORS=OFF
    -DUDEV_RULES_PATH=$PREFIX/lib/udev/rules.d
)

cmake ${CMAKE_ARGS} -G "Ninja" .. "${cmake_config_args[@]}"
cmake --build . --config Release -- -j${CPU_COUNT}

cmake --build . --config Release --target install

# add post-link script with instructions for manually linking udev rules
if [[ $target_platform == linux* ]] ;
    mkdir -p $PREFIX/bin
    cp $RECIPE_DIR/post-link.sh $PREFIX/bin/.bladerf-post-link.sh
    chmod +x $PREFIX/bin/.bladerf-post-link.sh
fi
