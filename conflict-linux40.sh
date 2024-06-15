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

pijul fork m

tar -xJf ../../pijul-tests/kernel/linux-2.0.40.tar.xz --strip-components=1
add
record

pijul channel switch m
xzcat ../../pijul-tests/patches/patch-2.0.2.xz | patch -sp1
record
H="$(pijul log --hash-only | head -1)"
pijul apply "${H}" --channel main

pijul channel switch main
pijul unrecord "${H}"
rm -rf -- *
tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

echo "OK--conflict-linux40"
