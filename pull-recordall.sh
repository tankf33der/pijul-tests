#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
pijul clone repo repo2
cd repo

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

for i in {2..40}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -Esp1
   add
   record
done

H="$(pijul log --hash-only | head -1)"
pijul pull --repository ../repo2 -- "$H"

cd ../repo2
eq 2090994418 "$(cksum Makefile | awk '{print $1}')"

echo "OK--pull-recordall"
