#!/bin/bash -xe

QTVER=6.4.3
EMVER=3.1.14
QT_HOST_PATH=~/Qt${QTVER}/${QTVER}/gcc_64
QTWASM=~/Documents/qtwasm-${QTVER}

export PATH=${PATH}:${QT_HOST_PATH}

TAR=~/Downloads/qt-everywhere-src-${QTVER}.tar

cd ~/emsdk
./emsdk activate ${EMVER}
source emsdk_env.sh

clean_qtwasm() {
  if [ -d "${QTWASM}" ]; then
    rm -rf "${QTWASM}"
  fi
}

unpack_tarball() {
  if [ -d "${QTWASM}" ]; then
    return
  fi
  if [ ! -d "${QTWASM}" ]; then
    mkdir -p "${QTWASM}"
  fi
  tar -C "${QTWASM}" -xf "${TAR}" --strip-components=1
  rm -rf "${QTWASM}/qtwebengine"
}

configure_qtkit() {
  cd "${QTWASM}"
  cmd=()
  cmd+=( ./configure )
  cmd+=( -qt-host-path ${QT_HOST_PATH} )
  cmd+=( -platform     wasm-emscripten )
  cmd+=( -nomake       examples )
  cmd+=( -prefix       $PWD/qtbase  )
  "${cmd[@]}"
}

build_qtkit() {
  cd "${QTWASM}"

  cmd=()
  cmd+=( cmake )
  cmd+=( --build . )
  cmd+=( -t qtbase )
  cmd+=( -t qtdeclarative )
  cmd+=( -t qtimageformats )
  cmd+=( -t qtsvg )
  # cmd+=( -t qtquickcontrols2 )
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
echo 1001 clean_qtwasm
clean_qtwasm
echo 1002 unpack_tarball
unpack_tarball
echo 1003 configure_qtkit
configure_qtkit
echo 1004 build_qtkit
build_qtkit

cd "${QTWASM}"
pwd
ls

