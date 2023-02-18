#!/usr/bin/env bash
# https://nest.pijul.com/pijul/pijul/discussions/400
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

mkdir -p 1/2/3/4
echo "mikeiscool" >> 1/2/3/4/7
add
record

pijul mv 1 2
record
H=$(pijul log --hash-only | head -1)
pijul unrec --reset "$H"

echo "OK--unrec-dir"
