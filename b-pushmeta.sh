#!/usr/bin/env bash

set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
pijul clone repo repo2
cp ../pijul-tests/B.txt repo2/A.txt
cp ../pijul-tests/assert.py repo2/
cd repo2

echo "OK--b-pushmeta"
