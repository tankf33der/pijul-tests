#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

cd ..
pijul clone repo repo2
eq 0 "$(diff -qr repo repo2 | grep -cv ".pijul")"

rm -rf repo2

echo "OK--clone"
