#!/usr/bin/env bash
# https://nest.pijul.com/pijul/pijul/discussions/416
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

touch a
pijul add a
record
pijul fork m1
pijul channel switch m1
echo "mikeiscool" >> a
record

pijul channel switch main
pijul channel delete m1
H=$(pijul log --hash-only | head -1)
pijul unrecord --reset "$H"
pijul channel switch m1 || exit 0	# workaround

echo "OK--fork-unrec"
