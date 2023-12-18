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
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
   add
   record

   cd ..
   mv repo repo2
   pijul clone repo2 repo
   rm -rf repo2
   cd repo
done
crc Makefile 2090994418

cd ..
mkdir linux2040
cd linux2040
tar -xJf ../../pijul-tests/kernel/linux-2.0.40.tar.xz --strip-components=1
cd ..
eq 0 "$(diff -qr repo linux2040 | grep -cv "Only in")"

echo "OK--clone-matryoshka"
