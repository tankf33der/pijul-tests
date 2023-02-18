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

for i in {2..40}; do
   C=$(pijul log --hash-only | head -1)
   pijul fork "$i"
   pijul apply "$C" --channel "$i"
   pijul channel switch "$i"
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
   add
   record
   C=$(pijul log --hash-only | head -1)
   pijul apply "$C" --channel main
   pijul channel switch main
done

MAKE=$(cksum Makefile | awk '{print $1}')
eq 2090994418 "$MAKE"

echo "OK--zigzag"
