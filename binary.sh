#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

pijul archive --prefix pijul -o mike
add
record

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

for i in {2..16}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
   add
   record

   pijul archive --prefix pijul -o mike
   record
done

cd ..
pijul clone repo repo2
cd repo2

gunzip -t mike.tar.gz

echo "OK--binary"
