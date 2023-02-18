#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

pijul add -rf .pijul
record

pijul add -rf .pijul
record

cd ..
pijul clone repo repo2

echo "OK--add-pristine"
