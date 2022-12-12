#!/bin/bash -xe

QTVER=6.4.1
TAR=~/Downloads/qt-everywhere-src-${QTVER}.tar
WORKDIR=~/Documents/qtwasm-${QTVER}

cd ~/emsdk
./emsdk activate 3.1.14
source emsdk_env.sh

clean_workdir() {
  if [ -d "${WORKDIR}" ]; then
    rm -rf "${WORKDIR}"
  fi
}

unpack_tarball() {
  if [ -d "${WORKDIR}" ]; then
    return
  fi
  if [ ! -d "${WORKDIR}" ]; then
    mkdir -p "${WORKDIR}"
  fi
  tar -C "${WORKDIR}" -xf "${TAR}" --strip-components=1
  rm -rf "${WORKDIR}/qtwebengine"
}

configure_qtkit() {
  cd "${WORKDIR}"
  cmd=()
  cmd+=( ./configure )
  cmd+=( -qt-host-path ~/Qt${QTVER}/${QTVER}/gcc_64)
  cmd+=( -platform     wasm-emscripten )
  cmd+=( -nomake       examples )
  cmd+=( -prefix       $PWD/qtbase  )
  "${cmd[@]}"
}

build_qtkit() {
  cd "${WORKDIR}"

  cmd=()
  cmd+=( cmake )
  cmd+=( --build . )
  cmd+=( -t qtbase )
  cmd+=( -t qtdeclarative )
  cmd+=( -t qtimageformats )
  cmd+=( -t qtsvg )
  # cmd+=( -t qtquickcontrols2 )
  cmd+=( -t qtnetworkauth )
  cmd+=( -t qt3d )
  cmd+=( -t qtquick3d )
  cmd+=( -t qtmultimedia )
  # cmd+=( -t qtcharts )
  cmd+=( -t qtvirtualkeyboard )
  cmd+=( -t qt5compat )

  # Failed
  # cmd+=( -t qtquickcontrols )
  # cmd+=( -t qtgraphicaleffects )

  # TODO
  # cmd+=( -t qtnetworkauth )
  # cmd+=( -t qtscxml )
  # cmd+=( -t qtmultimedia )
  # cmd+=( -t qttranslations )
  # cmd+=( -t qtmacextras )
  # cmd+=( -t qtx11extras )
  # cmd+=( -t qtandroidextras )
  # cmd+=( -t qtserialport )
  # cmd+=( -t qtserialbus )
  # cmd+=( -t qtactiveqt )
  # cmd+=( -t qtquicktimeline )
  # cmd+=( -t qtlottie )
  # cmd+=( -t qtremoteobjects )
  # cmd+=( -t qtpurchasing )
  # cmd+=( -t qtwebsockets )
  # cmd+=( -t qtwebglplugin )
  # cmd+=( -t qtwebchannel )
  # cmd+=( -t qtgamepad )
  # cmd+=( -t qtwayland )
  # cmd+=( -t qtconnectivity )
  # cmd+=( -t qtsensors )
  # cmd+=( -t qtlocation )
  # cmd+=( -t qtxmlpatterns )
  # cmd+=( -t qtspeech )
  # cmd+=( -t qtdatavis3d )
  # cmd+=( -t qtwinextras )
  # cmd+=( -t qttools )
  # cmd+=( -t qtscript )
  # cmd+=( -t qtwebengine )
  # cmd+=( -t qtwebview )
  # cmd+=( -t qtd )
  # cmd+=( -t qtpositioning )

  # Run
  "${cmd[@]}"
}

echo 1000 tests
which cmake
cmake --version
echo 1001 clean_workdir
clean_workdir
echo 1002 unpack_tarball
unpack_tarball
echo 1003 configure_qtkit
configure_qtkit
echo 1004 build_qtkit
build_qtkit

cd "${WORKDIR}"
pwd
ls

