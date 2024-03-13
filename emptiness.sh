#!/usr/bin/env bash
# https://nest.pijul.com/pijul/pijul/discussions/415
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
done

pijul fork emptiness
pijul channel switch emptiness

# milestone #1
eq 0 "$(pijul diff --short | wc -l)"
rm -rf -- *
pijul reset --force
eq 0 "$(pijul diff --short | wc -l)"

# milestone #2
for i in {0..40}; do
	H=$(pijul log --hash-only | head -1)
	pijul unrecord "$H"
done
rm -rf -- *
eq 1 "$(pijul diff --short | wc -l)"
record

pijul channel switch main
eq 0 "$(pijul diff --short | wc -l)"
crc Makefile 2090994418
pijul channel switch emptiness
crc Makefile 2090994418

echo "OK--emptiness"
