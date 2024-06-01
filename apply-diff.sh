#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo
pijul fork m

tar -xJf ../../pijul-tests/kernel/linux-4.14.1.tar.xz --strip-components=1
add
record

for i in {1..335}; do
   xzcat ../../pijul-tests/patches/patch-4.14."$i"-*.xz | patch -Esp1
   add
   record

   H="$(pijul log --hash-only | head -1)"
   pijul apply "${H}" --channel m
   pijul channel switch m
   pijul channel switch main
   zero $(pijul diff -su --channel m | wc -l)
done

echo "OK--apply-diff"
