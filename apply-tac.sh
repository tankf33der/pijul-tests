#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo
pijul fork Reverse

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

for i in {2..40}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -Esp1
   add
   record
done

for H in $(pijul log --hash-only | tac); do
	pijul apply --channel Reverse "$H"
	eq 2 "$(pijul channel | wc -l)"
done

pijul channel switch Reverse
crc Makefile 2090994418
pijul channel switch main
crc Makefile 2090994418

echo "OK--apply-tac"
