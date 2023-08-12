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
pijul tag create -m"201"
MAIN="$(cksum Makefile | awk '{print $1}')"
HASH="$(pijul tag | awk '{print $2}' | head -1)"

for i in {2..40}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
done

pijul tag reset "$HASH"
eq "$MAIN" "$(cksum Makefile | awk '{print $1}')"

echo "OK--tag-reset"
