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
EDITOR=true pijul record -m"."
eq 2143 "$(pijul ls | wc -l)"

for i in {2..40}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
   add
   EDITOR=true pijul record -m"."
done

eq 2484 "$(pijul ls | wc -l)"

echo "OK--rec-editor"
