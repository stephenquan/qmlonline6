#!/bin/bash -xe

QTVER=6.4.3
QTWASM=~/Documents/qtwasm-${QTVER}
QMLONLINE=/tmp/qmlonline6

cd ${QMLONLINE}
python3 ${QTWASM}/qtbase/util/wasm/qtwasmserver/qtwasmserver.py  --all

