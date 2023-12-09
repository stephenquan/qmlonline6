#!/bin/bash -xe

# pushd ~/emsdk
# ./emsdk activate 3.1.14
QTVER=6.4.3
QTWASM=~/Documents/qtwasm-${QTVER}
QMLONLINE=/tmp/qmlonline6
SRCDIR=~/Documents/Qt/qmlonline/qmlonline6

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

mkdir -p ${QMLONLINE}
cd ${QMLONLINE}
${QTWASM}/qtbase/bin/qt-cmake ${SRCDIR}
cmake --build .

