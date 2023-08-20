#!/usr/bin/env bash
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
pijul rec -am"."
H=$(pijul log --hash-only | head -1)
pijul channel new t1
pijul channel switch t1
pijul apply "$H"

crc a 4294967295

echo "OK--apply-cross"
