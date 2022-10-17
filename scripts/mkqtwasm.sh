#!/bin/bash -xe

QTVER=6.4.0
TAR=~/Downloads/qt-everywhere-src-6.4.0.tar
WORKDIR=~/Documents/qtwasm640

cd ~/emsdk
./emsdk activate 3.1.14
source emsdk_env.sh

unpack_tarball() {
  if [ -d "${WORKDIR}" ]; then
    rm -rf "${WORKDIR}"
  fi
  if [ ! -d "${WORKDIR}" ]; then
    mkdir -p "${WORKDIR}"
  fi
  tar -C "${WORKDIR}" -xf "${TAR}" --strip-components=1
}

configure_qtkit() {
  cd "${WORKDIR}"
  cmd=()
  cmd+=( ./configure )
  cmd+=( -qt-host-path ~/Qt6.4.0/6.4.0/gcc_64)
  cmd+=( -xplatform    wasm-emscripten )
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
  cmd+=( -t qtquickcontrols2 )
  cmd+=( -t qtnetworkauth )
  cmd+=( -t qt3d )
  cmd+=( -t qtquick3d )
  cmd+=( -t qtmultimedia )

  # Failed
  # cmd+=( -t qtquickcontrols )

  # TODO
  # make module-qtnetworkauth
  # make module-qtscxml
  # make module-qtgraphicaleffects
  # make module-qtmultimedia
  # make module-qtcharts
  # make module-qttranslations
  # make module-qtmacextras
  # make module-qtx11extras
  # make module-qtandroidextras
  # make module-qtserialport
  # make module-qtserialbus
  # make module-qtactiveqt
  # make module-qtquicktimeline
  # make module-qtlottie
  # make module-qtremoteobjects
  # make module-qtpurchasing
  # make module-qtwebsockets
  # make module-qtwebglplugin
  # make module-qtwebchannel
  # make module-qtgamepad
  # make module-qtwayland
  # make module-qtconnectivity
  # make module-qtsensors
  # make module-qtlocation
  # make module-qtxmlpatterns
  # make module-qtspeech
  # make module-qtvirtualkeyboard
  # make module-qtdatavis3d
  # make module-qtwinextras
  # make module-qttools
  # make module-qtscript
  # make module-qtwebengine
  # make module-qtwebview
  # make module-qtd

  # Run
  "${cmd[@]}"
}

unpack_tarball
configure_qtkit
build_qtkit

cd "${WORKDIR}"
pwd
ls

