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
pijul add -r drivers kernel net
EDITOR=true pijul record -m"."

eq 670 "$(pijul ls | wc -l)"

for i in {2..40}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
   pijul add -r drivers kernel net
   EDITOR=true pijul record -m"."
done

eq 903 "$(pijul ls | wc -l)"
crc Makefile 2090994418

echo "OK--rec-editor"
