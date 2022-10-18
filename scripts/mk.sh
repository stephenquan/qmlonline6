#!/bin/bash -xe

# pushd ~/emsdk
# ./emsdk activate 3.1.14
source ~/emsdk/emsdk_env.sh

export EXPORTED_RUNTIME_METHODS=ccall,cwrap,UTF16ToString,stringToUTF16,specialHTMLTargets

rm -rf CMakeCache.txt
rm -rf CMakeFIles
rm -rf Makefile
rm -rf cmake_install.cmake
rm -rf qt6-hello-app.html
rm -rf qt6-hello-app.js
rm -rf qt6-hello-app.wasm
rm -rf qt6-hello-app_autogen
rm -rf qtloader.js
rm -rf qtlogo.svg

export GIT_COMMIT=$(git log -1 --format=%h)
echo "GIT_COMMIT=${GIT_COMMIT}"

mkdir -p out
cd out
~/Documents/qtwasm640/qtbase/bin/qt-cmake ..
cmake --build .

