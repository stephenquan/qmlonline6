#!/bin/bash -e

QMLONLINE=/tmp/qmlonline6
WASMFILE=qmlonline6.wasm

if [ "${AGOL_USER}" == "" ]; then
  read -p "ArcGIS Online Username? " AGOL_USER
fi
if [ "${AGOL_PASSWORD}" == "" ]; then
  read -p "ArcGIS Online Password? " AGOL_PASSWORD
fi

mkdir -p /tmp/agol

curl https://www.arcgis.com/sharing/rest/search --data q="${WASMFILE}" --data f=pjson > /tmp/agol/search.json
AGOL_ITEM=$(perl -ne 'if (/id": "(.*)"/) { print $1 . "\n" }' < /tmp/agol/search.json)
if [ "${AGOL_ITEM}" == "" ]; then
  curl https://www.arcgis.com/sharing/rest/search --data q="qmlonline6.wasm" --data f=json
  exit 1
fi

curl -X POST https://www.arcgis.com/sharing/rest/generateToken --data username=${AGOL_USER} --data-urlencode password=${AGOL_PASSWORD} --data referer=https://www.arcgis.com --data f=pjson > /tmp/agol/token.json
token=$(perl -ne 'if (/token": "(.*)"/) { print $1 . "\n" }' < /tmp/agol/token.json)
if [ "$token" == "" ]; then
  cat /tmp/agol/token.json
  echo
  exit 1
fi

(cd ${QMLONLINE}; curl https://www.arcgis.com/sharing/rest/content/users/${AGOL_USER}/items/${AGOL_ITEM}/update -F f=pjson -F file=@${WASMFILE} -F token=${token})

