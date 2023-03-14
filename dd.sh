#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

dd if=/dev/zero of=a bs=1024 count=102400
pijul add a
time pijul record -am"."

echo "OK--dd"
