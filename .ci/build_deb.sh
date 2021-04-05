#!/usr/bin/env bash
set -e

od=$(pwd)
mkdir -p pkg/${MATRIX_OS}/opt
rsync --delete -a _build/prod/rel/fireguard pkg/${MATRIX_OS}/opt/
cd pkg
dpkg-deb --build ${MATRIX_OS}
mv -f ${MATRIX_OS}.deb ../fireguard_${MATRIX_OS}_amd64.deb