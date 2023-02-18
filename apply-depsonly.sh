#!/usr/bin/env bash
# https://nest.pijul.com/pijul/pijul/discussions/398
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

pijul fork Empty
tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

for i in {2..34}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
   add
   record
done

H=$(pijul log --hash-only | head -1)
pijul apply "$H" --deps-only --channel Empty
pijul channel switch Empty
eq 2274700269 "$(cksum Makefile | awk '{print $1}')"

echo "OK--apply-depsonly"
